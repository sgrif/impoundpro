class RenameCarTrimsToTrims < ActiveRecord::Migration
  def change
    rename_table :car_trims, :trims
    rename_table :car_trims_years, :trims_years
    rename_column :trims_years, :car_trim_id, :trim_id
    rename_column :cars, :car_trim_id, :trim_id
  end
end
