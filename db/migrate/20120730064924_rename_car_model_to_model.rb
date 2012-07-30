class RenameCarModelToModel < ActiveRecord::Migration
  def change
    rename_table :car_models, :models
    rename_table :car_models_car_years, :car_years_models
    rename_column :car_years_models, :car_model_id, :model_id
    rename_column :car_trims, :car_model_id, :model_id
    rename_column :cars, :car_model_id, :model_id
  end
end
