class PaypalPayment
  def initialize(user)
    @user = user
  end
  
  def checkout_details
    process :checkout_details
  end
  
  def checkout_url(options)
    process(:checkout, options).checkout_url
  end
  
  def make_recurring
    process :request_payment
    process :create_recurring_profile, :period => :monthly, :frequency => 1, :start_at => Time.zone.now
  end
  
  def cancel
    process :cancel, :profile_id => @user.paypal_recurring_profile_token
  end
  
  private
  
  def process(action, options = {})
    options = options.reverse_merge(
      :token => @user.paypal_payment_token,
      :payer_id => @user.paypal_customer_token,
      :description => "Desc", # TODO Description & Price
      :amount => 5,
      :currency => "USD"
    )
    response = PayPal::Recurring.new(options).send(action)
    puts response.errors if response.errors.present?
    raise response.errors.inspect if response.errors.present?
    response
  end
  
end