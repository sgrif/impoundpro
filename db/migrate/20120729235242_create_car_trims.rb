class CreateCarTrims < ActiveRecord::Migration
  def change
    create_table :car_trims do |t|
      t.integer :car_model_id
      t.string :name

      t.timestamps
    end
  end
end
