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
      webhook = user.stripe_webhooks.build(:type => params[:stripe_webhook][:type], event_id: params[:stripe_webhook][:id], target_id: params[:data][:object][:id])
      if webhook.save!
        process_webhook webhook
      end
    end

    render nothing: true
  end

  def process_webhook(webhook)

    target = webhook.type.split('.')[0]
    action = webhook.type.split('.')[1]

    if target == "charge"
      if action == "succeeded"
        webhook.user.update_attribute(:paid, true)
      elsif action == "failed"
        webhook.user.update_attribute(:paid, false)
      end
    elsif target == "invoice"
      if action == "payment_succeeded"
        webhook.user.update_attribute(:paid, true)
      elsif action == "payment_failed"
        webhook.user.update_attribute(:paid, false)
      end
    elsif target == "invoiceitem"
      car = Car.find_by_stripe_invoice_item_token(webhook.target_id)
      if car
        car.update_attribute(:paid, true)
      end
    end

  end
end
