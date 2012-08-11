class CreateTowRecords < ActiveRecord::Migration
  def change
    create_table :tow_records do |t|
      t.integer :car_id
      t.date :date_towed
      t.string :tow_requester, limit: 50
      t.string :tow_reason, limit: 50
      t.string :driver_name, limit: 50
      t.string :driver_address, limit: 127
      t.string :driver_city, limit: 50
      t.string :driver_state, limit: 4
      t.string :driver_zip, limit: 10

      t.timestamps
    end
  end
end
