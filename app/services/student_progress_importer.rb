require 'open-uri'
require 'capybara_scraper'
require 'typhoeus'

options = {js_errors: false}
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end

class StudentProgressImporter 
  BASE_URL = 'https://learn.co/api/v1'

  attr_reader :batch_id
  def initialize(batch_id)
    @batch_id = batch_id
  end

  def session 
    @session ||= login_user(Rails.application.credentials.dig(:learn_email), Rails.application.credentials.dig(:learn_password))
  end

  def fetch 
    # student_progress = Struct.new(:full_name, :completed_lessons_count, :total_lessons_count, :email)
    # result = data["students"].map do |h| 
    #   student_progress.new(h["full_name"], h["completed_lessons_count"], h["total_lessons_count"], h["email"])
    # end
    # data
    session.visit("#{BASE_URL}/batches/#{batch_id}.json")
    data = JSON.parse(@session.text)
    
  end

  def login_user(email, password)
    @session = Capybara::Session.new(:poltergeist)

    @session.visit('https://learn.co')
    @session.fill_in "user-email", with: email
    @session.fill_in "user-password", with: password
    puts "Signing in now..."
    sleep 0.5
    @session.click_button "Sign in"
    if @session.current_path == "/account_check/failure" || @session.current_path == "/"
      puts "Invalid email or password"
      puts "\n"
      byebug
    else 
      @session
    end
  end
end