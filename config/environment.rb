# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tyler::Application.initialize!

Time::DATE_FORMATS[:month_and_day] = "%B %d"
Time::DATE_FORMATS[:short_year] = "%y"
Time::DATE_FORMATS[:short_date] = "%m/%d/%Y"

# TODO Remove this for deployment
ENV['RAILS_ENV'] ||= 'production'
