class CreateCarYears < ActiveRecord::Migration
  def change
    create_table :car_years do |t|
      t.string :name

      t.timestamps
    end
  end
end
