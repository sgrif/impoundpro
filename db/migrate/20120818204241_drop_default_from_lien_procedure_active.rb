class DropDefaultFromLienProcedureActive < ActiveRecord::Migration
  def up
    change_column :lien_procedures, :active, :boolean
  end

  def down
    change_column :lien_procedures, :active, :boolean, default: true
  end
end
