class CreateStripeWebhooks < ActiveRecord::Migration
  def change
    create_table :stripe_webhooks do |t|
      t.integer :user_id
      t.string :type
      t.string :event_id

      t.timestamps
    end
  end
end
