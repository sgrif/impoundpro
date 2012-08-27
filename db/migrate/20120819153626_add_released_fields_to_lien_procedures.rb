class AddReleasedFieldsToLienProcedures < ActiveRecord::Migration
  def change
    add_column :lien_procedures, :vehicle_released, :boolean
    add_column :lien_procedures, :personals_released, :boolean
  end
end
