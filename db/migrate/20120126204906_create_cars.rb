class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :uid, :primary => true, :auto_increment => true
      t.integer :year
      t.string :make
      t.string :model
      t.string :size
      t.string :state
      t.string :vin
      t.string :license_plate_number
      t.datetime :date_towed
      t.string :tow_requested_by
      t.string :tow_reason
      t.datetime :mail_notice_of_lien_date
      t.string :owner_name
      t.string :owner_address
      t.string :owner_city_state_zip
      t.string :lien_holder_name
      t.string :lien_holder_address
      t.string :lien_holder_city_state_zip
      t.decimal :charge_towing, :precision => 8, :scale => 2
      t.decimal :charge_storage, :precision => 8, :scale => 2
      t.decimal :charge_admin, :precision => 8, :scale => 2
      t.float :tax, :precision => 1, :scale => 4
      t.decimal :storage_rate, :precision => 8, :scale => 2
      t.boolean :mvd_inquiry_made
      t.string :preparers_name

      t.timestamps
    end
  end
end
