class Item < ApplicationRecord
  include Filterable
  
  belongs_to :merchant
  has_many :item_invoices
  has_many :invoices, through: :item_invoices
  scope :filter_by_name, -> (name) { where("lower(name) like ?", "%#{name.downcase}%") }
  scope :filter_by_description, -> (description) { where("lower(description) like ?", "%#{description.downcase}%") }
  scope :filter_by_unit_price, -> (price) { where(unit_price: price) }
  scope :filter_by_merchant_id, -> (merchant_id) { where(merchant_id: merchant_id) }
end
