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

  @@session = nil
  def self.session 
    if @@session
      @@session
    else
      @@session = login_user(Rails.application.credentials.dig(:schedule_once_email), Rails.application.credentials.dig(:schedule_once_password))
      sleep 2
      @@session
    end    
  end

  def self.fetch 
    session.find('.oui-dialog-header-close').click
    session.visit("https://app.oncehub.com/scheduleonce/Activity.aspx?free_text_search=structured%20portfolio%20project%20review")
    results = {}
    previous_lengths = [-1,0]
    # grab data for 5 meetings at a time
    until previous_lengths[-3] == previous_lengths[-2] && previous_lengths[-2] == previous_lengths[-1]
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
      # sleep 1
      # click on all of the meetings on the left hand side and 
      # add data from right hand side details view
      selected_meeting_index = 0
      while selected_meeting_index < 5
        #scroll to the bottom of the details container
        sleep 1.5
        js = <<-JS
          var c = document.querySelector('#activityDetailContainer'); 
          var offset = 446-c.scrollHeight; 
          c.style.position = 'relative'; 
          c.style.top = offset+'px';
        JS
        session.execute_script(js)
        
        # add the data to the corresponding hash
        text = session.find('.activityDetail').text
        data[selected_meeting_index][:github_url] = text.match(/(https:\/\/github.com\/.+)/).try(:[],0)
        data[selected_meeting_index][:cohort_name] = text.match(/(online-web-[pf]t-\d+)/).try(:[],1)
        data[selected_meeting_index][:learn_profile_url] = text.match(/(https:\/\/w*\.?learn.co\/.+)\s/).try(:[],1)
        data[selected_meeting_index][:assessment] = session.find_all('.activityDetail p').last.text
        selected_meeting_index += 1
        session.find_all('.activityStreamListing li')[selected_meeting_index].click
      end
      # load the data into the results hash
      data.each {|d| results["#{d[:name]} at #{d[:date]}"] = d}
      # add the length of the results to the previous lengths array for terminating the while loop
      previous_lengths << results.length
      session.scroll_to(session.find_all('.activityStreamListing li').last)
    end
    # filter out the canceled meetings
    results.select do |k,v| 
      ["Completed", "Scheduled"].include?(v[:status]) &&
      v[:cohort_name]
    end.values
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