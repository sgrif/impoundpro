class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.string :name
      t.string :address
      t.string :city_state_zip

      t.timestamps
    end
  end
end
