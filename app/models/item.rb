class Item < ApplicationRecord
  belongs_to :merchant
  has_many :item_invoices
  has_many :invoices, through: :item_invoices
end
