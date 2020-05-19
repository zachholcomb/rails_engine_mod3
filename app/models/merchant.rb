class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :item_invoices, through: :invoices
  has_many :transactions, through: :invoices
  scope :filter_by_name, -> (name) { where("lower(name) like ?", "%#{name.downcase}%") }
  scope :filter_by_created_at, -> (created_at) { where("Date(created_at) = ?", "#{created_at}") }
  scope :filter_by_updated_at, -> (updated_at) { where("Date(updated_at) = ?", "#{updated_at}") }

  def self.most_revenue(limit_quantity)
    Merchant.joins(:invoices, :item_invoices, :transactions)
            .where('transactions.result = 0')
            .select('merchants.*, sum(item_invoices.unit_price * item_invoices.quantity) as revenue')
            .group(:id)
            .order('revenue desc')
            .limit(limit_quantity)
  end
end
