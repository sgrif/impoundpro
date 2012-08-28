class AddFinishedFieldsToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :claimed, :boolean, default: false, null: false
    add_column :lien_procedures, :scrapped, :boolean, default: false, null: false
  end
end
