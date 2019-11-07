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

class BatchImporter 
  BASE_URL = 'https://learn.co/api/v1'
  def self.import 
    web_batches = self.data["batches"].select do |b| 
      b["iteration"].match('online-web')
    end.map do |h| 
      {
        "iteration" => h["iteration"],
        "batch_id" => h["id"]
      }
    end
    web_batches.each do |web_batch| 
      batch = Batch.find_by_batch_id(web_batch["batch_id"])
      if batch
        batch.update(name: web_batch["iteration"])
      else 
        Batch.create(name: web_batch["iteration"], batch_id: web_batch["batch_id"])
      end
    end
  end

  def self.data
    @@data ||= fetch
  end

  def self.session 
    @@session ||= login_user(Rails.application.credentials.dig(:learn_email), Rails.application.credentials.dig(:learn_password))
  end

  def self.fetch 
    session.visit("#{BASE_URL}/organizations/27.json")
    data = JSON.parse(session.text)
  end

  def self.login_user(email, password)
    @@session = Capybara::Session.new(:headless_chrome)
    
    @@session.visit('https://learn.co')
    @@session.fill_in "user-email", with: email
    @@session.fill_in "user-password", with: password
    puts "Signing in now..."
    sleep 0.5
    @@session.click_button "Sign in"
    if @@session.current_path == "/account_check/failure" || @@session.current_path == "/"
      puts "Invalid email or password"
      puts "\n"
      byebug
    else 
      @@session
    end
  end
end