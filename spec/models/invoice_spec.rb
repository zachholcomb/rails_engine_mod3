require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:item_invoices) }
    it { should have_many(:items).through(:item_invoices) }
    it { should have_many :transactions}
  end
end
