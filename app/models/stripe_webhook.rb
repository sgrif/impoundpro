class StripeWebhook < ActiveRecord::Base
  belongs_to :user

  attr_accessible :type, :event_id, :target_id
end
