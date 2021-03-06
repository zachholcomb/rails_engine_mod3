class Merchant < ApplicationRecord
  include Filterable

  has_many :items
  has_many :invoices
  has_many :item_invoices, through: :invoices
  has_many :transactions, through: :invoices
  scope :filter_by_name, -> (name) { where("lower(name) like ?", "%#{name.downcase}%") }
  scope :filter_by_created_at, -> (created_at) { where("Date(created_at) = ?", "#{created_at}") }
  scope :filter_by_updated_at, -> (updated_at) { where("Date(updated_at) = ?", "#{updated_at}") }

  def self.most_revenue(limit_quantity)
   joins(:item_invoices, :transactions)
   .merge(Transaction.successful)
   .select('merchants.*, sum(item_invoices.unit_price * item_invoices.quantity) as revenue')
   .group(:id)
   .order('revenue desc')
   .limit(limit_quantity)
  end

  def self.most_items(limit_quantity)
   joins(:item_invoices, :transactions)
   .merge(Transaction.successful)
   .select('merchants.*, sum(item_invoices.quantity) as quantity')
   .group(:id)
   .order('quantity desc')
   .limit(limit_quantity)
  end

  def self.revenue(merchant_id)
    joins(invoices: [:item_invoices, :transactions])
    .merge(Transaction.successful)
    .where(id: merchant_id)
    .sum('item_invoices.quantity * item_invoices.unit_price')
  end

  def self.revenue_date_range(start_date, end_date)
    joins(invoices: [:item_invoices, :transactions])
    .merge(Transaction.successful)
    .where('date(invoices.created_at) BETWEEN ? AND ?', start_date, end_date)
    .sum('item_invoices.quantity * item_invoices.unit_price')
  end
end
