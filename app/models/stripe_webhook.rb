class StripeWebhook < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :type, :event_id
end
