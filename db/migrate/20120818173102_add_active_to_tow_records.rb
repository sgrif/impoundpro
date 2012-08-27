class AddActiveToTowRecords < ActiveRecord::Migration
  def change
    add_column :tow_records, :active, :boolean, :default => true
  end
end
