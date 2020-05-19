require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) } 
    it { should have_many(:item_invoices).through(:invoices) }
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

    it "most_revenue" do
      customer1 = create(:customer)
      customer2 = create(:customer)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)

      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant2)
      item3 = create(:item, merchant: merchant3)

      invoice1 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0)
      invoice2 = Invoice.create!(customer: customer2, merchant: merchant2, status: 0)
      invoice3 = Invoice.create!(customer: customer1, merchant: merchant3, status: 0)
      invoice4 = Invoice.create!(customer: customer2, merchant: merchant3, status: 0)

      item_invoice1 = ItemInvoice.create!(item: item1, invoice: invoice1, quantity: 1, unit_price: item1.unit_price)
      item_invoice2 = ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      item_invoice3 = ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      item_invoice4 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice5 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice6 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice7 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)

      transaction1 = Transaction.create!(invoice: invoice1, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction2 = Transaction.create!(invoice: invoice2, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction3 = Transaction.create!(invoice: invoice3, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction4 = Transaction.create!(invoice: invoice4, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)

      expect(Merchant.most_revenue(1)).to eq([merchant3])
    end
  end
end
