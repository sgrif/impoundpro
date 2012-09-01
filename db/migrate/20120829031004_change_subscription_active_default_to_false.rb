class ChangeSubscriptionActiveDefaultToFalse < ActiveRecord::Migration
  def up
    change_column :users, :subscription_active, :boolean, default: false
  end

  def down
    change_column :users, :subscription_active, :boolean
  end
end
