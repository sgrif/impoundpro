class AddTargetIdToStripeWebhooks < ActiveRecord::Migration
  def change
    add_column :stripe_webhooks, :target_id, :string

  end
end
