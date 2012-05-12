class ChangeDatesToDate < ActiveRecord::Migration
  def up
    change_column :cars, :date_towed, :date
  end

  def down
    change_column :cars, :date_towed, :datetime
  end
end
