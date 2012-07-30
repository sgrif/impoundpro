class CreateCarModelsCarYears < ActiveRecord::Migration
  def change
    create_table :car_models_car_years, :id => false do |t|
      t.references :car_model
      t.references :car_year
      t.timestamps
    end
  end

end
