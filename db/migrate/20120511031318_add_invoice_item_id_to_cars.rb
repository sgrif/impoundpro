class AddInvoiceItemIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :invoice_item_id, :string
  end
end
