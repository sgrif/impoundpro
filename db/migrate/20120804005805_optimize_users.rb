class OptimizeUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :password_digest, :string, :limit => 60
      t.remove :salt
      t.change :name, :string, :limit => 63
      t.change :address, :string, :limit => 127
      t.change :city, :string, :limit => 63
      t.change :state, :string, :limit => 4
      t.change :zip, :string, :limit => 15
      t.change :county, :string, :limit => 31
      t.change :phone_number, :string, :limit => 15
      t.change :auth_token, :string, :limit => 20
      t.change :password_reset_token, :string, :limit => 20
      t.change :preparers_name, :string, :limit => 50
      t.change :stripe_customer_token, :string, :limit => 20
    end
  end

  def down
    change_table :users do |t|
      t.column :salt, :string
      t.change :password_digest, :string
      t.change :name, :string
      t.change :address, :string
      t.change :city, :string
      t.change :state, :string
      t.change :zip, :string
      t.change :county, :string
      t.change :phone_number, :string
      t.change :auth_token, :string
      t.change :password_reset_token, :string
      t.change :preparers_name, :string
      t.change :stripe_customer_token, :string
    end
  end
end
