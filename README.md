# Getting Started

To get started we need to add your credentials to an encrypted file

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

now run 
```
rake setup
```
This will create the Batches, Students and import Projects.

## Importing Project Review appointments from ScheduleOnce

This last step is a bit tricky because SO may (rightly) assume that you're a bot and present a Captcha. If this happens it will break the script. But, there is a work around. Here are the steps.

1. open up `rails c`
2. run `ProjectReviewImporter.fetch` (This will either just work or open up the captcha. If the captcha appears move on to step 3)
3. fill in the captcha and hit submit.
4. close the chrome window that was opened by step 2.
5. close the rails console from step 1.
6. repeat steps 1 and 2 (this time it should work and you'll see something like the below in the console)

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
