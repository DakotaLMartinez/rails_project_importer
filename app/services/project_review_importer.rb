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
    close_button = session.find_all('.oui-dialog-header-close')
    close_button[0] && close_button[0].click
    session.visit("https://app.oncehub.com/scheduleonce/Activity.aspx?free_text_search=structured%20portfolio%20project%20review")
    results = {}
    cohorts_missing = 0
    until cohorts_missing > 0
      data = []
      sleep 1
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
        current_node = session.find_all('.activityStreamListing li')[selected_meeting_index]

        name, email, status, type, date = current_node.text.split("\n")
        detail_node = session.find('.activityDetail')
        text = ""
        counter = 0
        until text || counter == 100
          text = detail_node.text.match(/(https:\/\/github.com\/.+)/).try(:[],0)
          counter += 1
        end
        text = detail_node.text

        hash = {
          name: name,
          email: email,
          status: status, 
          type: type, 
          date: date,
          github_url: text.match(/(https:\/\/github.com\/.+)/).try(:[],0),
          cohort_name: text.match(/(online-web-[pf]t-\d+)/).try(:[],1),
          learn_profile_url: text.match(/(https:\/\/w*\.?learn.co\/.+)\s/).try(:[],1),
          assessment: session.find_all('.activityDetail p').last.text
        }
        data[selected_meeting_index] = hash
        
        break if ProjectReview.find_by(name: hash[:name], email: hash[:email], date: hash[:date], github_url: hash[:github_url], cohort_name: hash[:cohort_name], learn_profile_url: hash[:learn_profile_url], assessment: hash[:assessment])
        selected_meeting_index += 1
        session.find_all('.activityStreamListing li')[selected_meeting_index].click
      end
      # load the data into the results hash
      data.each {|d| results["#{d[:name]} at #{d[:date]}"] = d if (d[:name] && d[:date]) }
      puts "nil cohorts: #{data.select{|h| h[:cohort_name] == nil}.count}"
      cohorts_missing = data.select{|h| h[:cohort_name] == nil}.count
      
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
    sleep 2
    @@session.fill_in "email", with: email
    @@session.fill_in "password", with: password
    puts "Signing in now..."
    sleep 0.5
    @@session.click_button "Sign in"
    
    @@session
  end
end