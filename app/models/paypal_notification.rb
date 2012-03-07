class PaypalNotification
  def initialize(user, options = {})
    @user = user
    note = PayPal::Recurring::Notification.new(options)
    
    if note.type == 'recurring_payment_profile_cancel'
      user.paypal_recurring_profile_token = nil
    end
    
    puts note.response
  end
end