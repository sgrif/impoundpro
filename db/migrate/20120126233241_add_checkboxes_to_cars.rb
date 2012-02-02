class AddCheckboxesToCars < ActiveRecord::Migration
  def change
    add_column :cars, :has_registered_owner, :boolean

    add_column :cars, :has_lien_holder, :boolean

    add_column :cars, :has_charges, :boolean

  end
end
