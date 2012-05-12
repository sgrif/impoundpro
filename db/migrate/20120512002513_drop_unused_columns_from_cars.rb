class DropUnusedColumnsFromCars < ActiveRecord::Migration
  def up
    remove_column :cars, :charge_storage, :mail_notice_of_lien_date
  end

  def down
    change_table :cars do |t|
      t.datetime :mail_notice_of_lien_date
      t.decimal :charge_storage, :precision => 8, :scale => 2
    end
  end
end
