# Getting Started

After cloning, do a `bundle install`.

To get started we need to add your credentials to an encrypted file by running the following command. First, delete `config/credentials.yml.enc`.

```
EDITOR='code --wait' rails credentials:edit
```



add this stuff below the secret_key_base
```
learn_email: your@email.com
learn_password: yourpassword
schedule_once_email: your@email.com
schedule_once_password: yourpassword
```

## Set up the DB and import some data

### Install Chromedriver
For the next step, you'll need chromedriver installed. You can do that via homebrew or npm:

```
brew cask install chromedriver
```

```
npm install -g chromedriver
```
now run 
```
rake setup
```
This will create the Batches, Students and import Projects.

## Importing Project Review appointments from ScheduleOnce

This last step is a bit tricky because SO may (rightly) assume that you're a bot and present a Captcha. If this happens it will break the script. But, there is a work around. Here are the steps.

1. open up `rails c`
2. Create a user account using `User.create(email: "my@email.com", password: "password")`
3. run `ProjectReview.import(User.first)` (This will either just work by opening up a chrome window and successfully logging into scheduleonce or it will open up a captcha to have you prove you're not a robot. If the captcha appears move on to step 3)
4. fill in the captcha and hit submit.
5. close the chrome window that was opened by step 3.
6. close the rails console from step 1.
7. Open up a new `rails c`
8. run `ProjectReview.import(User.first)` again. This time

```
=> [{:name=>"Corbin Arnett",
  :email=>"corbin.c.arnett@gmail.com",
  :status=>"Scheduled",
  :type=>"Structured Portfolio Project Review",
  :date=>"Wed, Feb 5, 2020, 09:00 AM - 09:45 AM",
  :github_url=>"https://github.com/corbinarnett/vinylFile-frontend",
  :cohort_name=>"online-web-ft-081219",
  :learn_profile_url=>"https://learn.co/corbinarnett",
  :assessment=>"Final Portfolio Project"},
 {:name=>"joshua richards",
  :email=>"jermain119@gmail.com",
  :status=>"Scheduled",
  :type=>"Structured Portfolio Project Review",
  :date=>"Thu, Jan 30, 2020, 09:00 AM - 09:45 AM",
  :github_url=>"https://github.com/jermain119/cookme",
  :cohort_name=>"online-web-ft-100719",
:
```

##