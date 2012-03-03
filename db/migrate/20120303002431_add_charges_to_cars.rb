class AddChargesToCars < ActiveRecord::Migration
  def change
    add_column :cars, :charge_hook_up, :decimal, precision: 8, scale: 2

    add_column :cars, :charge_other, :decimal, precision: 8, scale: 2
    
    rename_column :cars, :charge_towing, :charge_mileage

  end
end
