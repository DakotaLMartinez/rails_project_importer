require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities,
    timeout: 180
end

Capybara.javascript_driver = :headless_chrome

class ProjectReviewImporter 
  def self.session 
    @@session ||= login_user(Rails.application.credentials.dig(:schedule_once_email), Rails.application.credentials.dig(:schedule_once_password))
  end

  def self.fetch 
    session.find('.oui-dialog-header-close').click
    session.visit("https://app.oncehub.com/scheduleonce/Activity.aspx?free_text_search=structured%20portfolio%20project%20review")
    results = {}
    review_count = session.find('.activityStreamCount').text.to_i
    previous_lengths = [-1,0]
    counter = 0
    until previous_lengths[-3] == previous_lengths[-2] && previous_lengths[-2] == previous_lengths[-1] && counter < 25
      data = session.find_all('li .userDetail').map do |ud|
        name, email, status, type, date = ud.text.split("\n")
        {
          name: name, 
          email: email,
          status: status, 
          type: type,
          date: date
        }
      end[0..4]
      data.each {|d| results["#{d[:name]} at #{d[:date]}"] = d}
      previous_lengths << results.length
      counter += 1
      session.scroll_to(session.find_all('.activityStreamListing li').last)
    end
    results.select{|k,v| ["Completed", "Scheduled"].include?(v[:status])}
  end

  def self.login_user(email, password)
    @@session = Capybara::Session.new(:headless_chrome)
    
    @@session.visit('https://account.oncehub.com/signin')
    @@session.fill_in "email", with: email
    @@session.fill_in "password", with: password
    puts "Signing in now..."
    sleep 0.5
    @@session.click_button "Sign in"
    
    @@session
  end
end