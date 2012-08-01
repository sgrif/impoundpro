class RemoveLongNameFromTrims < ActiveRecord::Migration
  def up
    remove_column :trims, :name
    rename_column :trims, :short_name, :name
  end

  def down
    rename_column :trims, :name, :short_name
    add_column :trims, :name, :string
  end
end
