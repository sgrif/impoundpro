class CreateCarTrimsCarYears < ActiveRecord::Migration
  def change
    create_table :car_trims_car_years, :id => false do |t|
      t.references :car_trim
      t.references :car_year
      t.timestamps
    end

    add_column :car_trims, :short_name, :string
  end
end
