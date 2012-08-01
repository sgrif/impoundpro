class FixJoinTables < ActiveRecord::Migration
  def change
    remove_timestamps :car_models_car_years
    remove_timestamps :car_trims_car_years
  end
end
