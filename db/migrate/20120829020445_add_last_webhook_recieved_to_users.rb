class AddLastWebhookRecievedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_webhook_recieved, :timestamp
  end
end
