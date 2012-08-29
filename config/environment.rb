# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ImpoundPro::Application.initialize!

Time::DATE_FORMATS[:month_and_day] = "%B %d"
Time::DATE_FORMATS[:short_year] = "%y"
Time::DATE_FORMATS[:short_date] = "%m/%d/%Y"

Date::DATE_FORMATS[:month_and_day] = "%B %d"
Date::DATE_FORMATS[:short_year] = "%y"
Date::DATE_FORMATS[:short_date] = "%m/%d/%Y"

DateTime::DATE_FORMATS[:month_and_day] = "%B %d"
DateTime::DATE_FORMATS[:short_year] = "%y"
DateTime::DATE_FORMATS[:short_date] = "%m/%d/%Y"

ActionMailer::Base.smtp_settings = {
  :address  => "smtp.gmail.com",
  :port  => 587,
  :domain => "impoundpro.com",
  :user_name  => ENV['MAIL_USER'],
  :password  => ENV['MAIL_PASS'],
  :authentication  => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default :from => "admin@impoundpro.com"
