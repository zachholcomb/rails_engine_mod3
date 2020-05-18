class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  scope :filter_by_name, -> (name) { where("lower(name) like ?", "%#{name.downcase}%") }
  scope :filter_by_created_at, -> (created_at) { where("Date(created_at) = ?", "#{created_at}") }
  scope :filter_by_updated_at, -> (updated_at) { where("Date(updated_at) = ?", "#{updated_at}") }
end
