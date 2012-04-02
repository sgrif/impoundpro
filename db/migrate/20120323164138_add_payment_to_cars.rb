class AddPaymentToCars < ActiveRecord::Migration
  def change
    add_column :cars, :stripe_invoice_item_token, :string

    add_column :cars, :paid, :boolean

  end
end
