class AddCarsCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :cars_count, :integer, default: 0

    User.reset_column_information
    User.all.each do |u|
      u.update_attribute :cars_count, u.cars.length
    end
  end

  def down
    remove_column :users, :cars_count
  end
end
