class CreateCarMakes < ActiveRecord::Migration
  def change
    create_table :car_makes do |t|
      t.string :name

      t.timestamps
    end
  end
end
