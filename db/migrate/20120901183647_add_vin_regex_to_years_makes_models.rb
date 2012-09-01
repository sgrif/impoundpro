class AddVinRegexToYearsMakesModels < ActiveRecord::Migration
  def change
    add_column :years, :vin_regex, :string
    add_column :makes, :vin_regex, :string
    add_column :models, :vin_regex, :string
  end
end
