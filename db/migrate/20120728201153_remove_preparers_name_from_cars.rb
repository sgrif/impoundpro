class RemovePreparersNameFromCars < ActiveRecord::Migration
  def up
    remove_column :cars, :preparers_name
  end

  def down
    add_column :cars, :preparers_name, :string
  end
end
