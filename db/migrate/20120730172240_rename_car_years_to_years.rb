class RenameCarYearsToYears < ActiveRecord::Migration
  def change
    rename_table :car_years, :years
    rename_table :car_trims_car_years, :car_trims_years
    rename_column :car_trims_years, :car_year_id, :year_id
    rename_table :car_years_models, :models_years
    rename_column :models_years, :car_year_id, :year_id
    rename_column :cars, :car_year_id, :year_id
  end
end
