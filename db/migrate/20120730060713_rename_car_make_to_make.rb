class RenameCarMakeToMake < ActiveRecord::Migration
  def change
    rename_table :car_makes, :makes
    rename_column :car_models, :car_make_id, :make_id
    rename_column :cars, :car_make_id, :make_id
  end
end
