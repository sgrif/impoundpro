class RenameTowRecordsToLienProcedures < ActiveRecord::Migration
  def up
    rename_table :tow_records, :lien_procedures
  end

  def down
    rename_table :lien_procedures, :tow_records
  end
end
