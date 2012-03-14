class AddPreparersNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preparers_name, :string
  end
end
