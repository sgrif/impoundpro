class DropUidFromCars < ActiveRecord::Migration
  def up
    remove_column :cars, :uid
  end

  def down
    add_column :cars, :uid, :integer
  end
end
