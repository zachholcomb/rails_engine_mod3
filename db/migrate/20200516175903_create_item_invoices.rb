class CreateItemInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :item_invoices do |t|
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :quantity
      t.float :unit_price

      t.timestamps
    end
  end
end
