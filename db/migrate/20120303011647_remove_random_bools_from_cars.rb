class RemoveRandomBoolsFromCars < ActiveRecord::Migration
  def up
    remove_column :cars, :has_registered_owner
        remove_column :cars, :has_charges
        remove_column :cars, :has_lien_holder
      end

  def down
    add_column :cars, :has_lien_holder, :boolean
    add_column :cars, :has_charges, :boolean
    add_column :cars, :has_registered_owner, :boolean
  end
end
