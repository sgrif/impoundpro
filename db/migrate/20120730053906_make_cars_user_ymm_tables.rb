class MakeCarsUserYmmTables < ActiveRecord::Migration
  def up
    change_table :cars do |t|
      t.remove :date_towed, :tow_requested_by, :tow_reason, :charge_mileage, :charge_admin, :tax,
        :storage_rate, :mvd_inquiry_made, :driver_name, :driver_address, :driver_city, :driver_state,
        :driver_zip, :charge_hook_up, :charge_other, :mail_notice_of_lien_date, :make, :model, :year
      t.references :car_year, :car_make, :car_model, :car_trim
    end
  end

  def down
    change_table :cars do |t|
      t.date :date_towed, :mail_notice_of_lien_date
      t.string :driver_name, :driver_address, :driver_city, :driver_state, :driver_zip,
        :year, :make, :model, :tow_requested_by, :tow_reason
      t.boolean :mvd_inquiry_made
      t.float :tax
      t.decimal :charge_mileage, :charge_admin, :storage_rate, :charge_hook_up, :charge_other,
        :precision => 8, :scale => 2

      t.remove :car_year, :car_make, :car_model, :car_trim
    end
  end
end
