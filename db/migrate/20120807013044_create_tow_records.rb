class CreateTowRecords < ActiveRecord::Migration
  def change
    create_table :tow_records do |t|
      t.integer :car_id
      t.date :date_towed
      t.string :tow_requester
      t.string :tow_reason
      t.string :driver_name
      t.string :driver_address
      t.string :driver_city
      t.string :driver_state
      t.string :driver_zip

      t.timestamps
    end
  end
end
