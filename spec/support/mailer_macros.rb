module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end
  
  def reset_email
    ActionMailer::Base.deliveries = []
  end
  
  def emails
    ActionMailer::Base.deliveries
  end
end

RSpec::Matchers.define :have_sent_email do
  match do |actual|
    last_email.nil? == false && @expected_to.eql?(last_email.to.to_s)
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual} would have sent an email to #{@expected_to} but instead went to #{last_email.to if last_email}"
  end
  
  def to(email)
    @expected_to = email.to_s
    self
  end
end