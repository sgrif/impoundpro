class RenamePaidOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :paid, :subscription_active
  end
end
