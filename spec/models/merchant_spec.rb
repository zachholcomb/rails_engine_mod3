require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many :invoices }
  end

  describe 'class methods' do
    it 'filter_by_name' do
      merchant = Merchant.create(name: 'Pied Piper')
      merchant2 = Merchant.create(name: "Pipe Fixers")

      expect(Merchant.filter_by_name('pied')).to eq([merchant])
      expect(Merchant.filter_by_name('pipe')).to eq([merchant, merchant2])
    end

    it 'filter_by_created_at' do
      merchant = create(:merchant)
      merchant2 = Merchant.create(name: "Applebees", created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")

      expect(Merchant.filter_by_created_at(merchant.created_at)).to eq([merchant])
    end

    it 'filter_by_updated_at' do
      merchant = create(:merchant)
      merchant2 = Merchant.create(name: "Applebees", created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")


      expect(Merchant.filter_by_updated_at(merchant.updated_at)).to eq([merchant])
    end
  end
end
