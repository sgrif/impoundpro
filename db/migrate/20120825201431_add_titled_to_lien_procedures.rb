class AddTitledToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :titled, :boolean, default: false, null: false
  end
end
