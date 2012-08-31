class StripeWebhooksController < ApplicationController
  skip_before_filter :authorize, :has_subscription
  # POST /stripe_webhooks
  # POST /stripe_webhooks.json
  def create

    if params[:data][:object][:object] == "customer"
      user_token = params[:data][:object][:id]
    else
      user_token = params[:data][:object][:customer]
    end

    user = User.find_by_stripe_customer_token user_token
    if user
      user.subscription_active = true if ["charge.succeeded", "invoice.payment_succeeded"].include? params[:type]
      user.subscription_active = false if ["charge.failed", "charge.disputed", "invoice.payment_failed", "invoice.payment_failed"].include? params[:type]
      user.last_webhook_recieved = Time.now
      user.save!
    end

    render nothing: true
  end

end
