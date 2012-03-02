class SeparateCityStateZip < ActiveRecord::Migration
  def up
    remove_column :cars, :owner_city_state_zip
    remove_column :cars, :lien_holder_city_state_zip
    remove_column :users, :city_state_zip
    
    add_column :cars, :owner_city, :string
    add_column :cars, :owner_state, :string
    add_column :cars, :owner_zip, :string
    
    add_column :cars, :lien_holder_city, :string
    add_column :cars, :lien_holder_state, :string
    add_column :cars, :lien_holder_zip, :string
    
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
  end

  def down
    remove_column :cars, :owner_city
    remove_column :cars, :owner_state
    remove_column :cars, :owner_zip
    remove_column :cars, :lien_holder_city
    remove_column :cars, :lien_holder_state
    remove_column :cars, :lien_holder_zip
    remove_column :users, :city
    remove_column :users, :state
    remove_column :users, :zip
    
    add_column :cars, :owner_city_state_zip, :string
    add_column :cars, :lien_holder_city_state_zip, :string
    add_column :users, :city_state_zip, :string
  end
end
