class AddDriverToCars < ActiveRecord::Migration
  def change
    add_column :cars, :driver_name, :string

    add_column :cars, :driver_address, :string

    add_column :cars, :driver_city, :string

    add_column :cars, :driver_state, :string

    add_column :cars, :driver_zip, :string

  end
end
