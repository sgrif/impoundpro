module StripeWebhookMacros
  def last_webhook
    StripeWebhook.last
  end
end
