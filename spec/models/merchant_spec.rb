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
      expect(Merchant.most_revenue(2)).to eq([merchant3, merchant2])
      expect(Merchant.most_revenue(3)).to eq([merchant3, merchant2, merchant1])
    end

    it 'most_items' do
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

      item_invoice1 = ItemInvoice.create!(item: item1, invoice: invoice1, quantity: 2, unit_price: item1.unit_price)
      item_invoice2 = ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 4, unit_price: item2.unit_price)
      item_invoice3 = ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 4, unit_price: item2.unit_price)
      item_invoice4 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice5 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice6 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      item_invoice7 = ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)

      transaction1 = Transaction.create!(invoice: invoice1, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction2 = Transaction.create!(invoice: invoice2, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction3 = Transaction.create!(invoice: invoice3, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      transaction4 = Transaction.create!(invoice: invoice4, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      expect(Merchant.most_items(1)).to eq([merchant2])
      expect(Merchant.most_items(2)).to eq([merchant2, merchant3])
      expect(Merchant.most_items(3)).to eq([merchant2, merchant3, merchant1])
    end

    it 'revenue' do
      customer1 = create(:customer)
      customer2 = create(:customer)
      merchant1 = create(:merchant)
      merchant3 = create(:merchant)

      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant3)

      invoice1 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0)
      invoice2 = Invoice.create!(customer: customer2, merchant: merchant1, status: 0)
      invoice3 = Invoice.create!(customer: customer1, merchant: merchant3, status: 0)
      invoice4 = Invoice.create!(customer: customer2, merchant: merchant3, status: 0)
      ItemInvoice.create!(item: item1, invoice: invoice1, quantity: 1, unit_price: item1.unit_price)
      ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice4, quantity: 1, unit_price: item3.unit_price)
      Transaction.create!(invoice: invoice1, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice2, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice3, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice4, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 1)
      expect(Merchant.revenue(merchant1.id)).to eq(4.5)
      expect(Merchant.revenue(merchant3.id)).to eq(4.5)
    end

    it 'revenue_date_range' do
      customer1 = create(:customer)
      merchant1 = create(:merchant)

      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant1)

      invoice1 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0, created_at: "1990-03-22 18:01:38 UTC")
      invoice2 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0, created_at: "1990-03-30 18:01:38 UTC")
      invoice3 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0, created_at: "1990-04-01 18:01:38 UTC")
      invoice4 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0, created_at: "1990-05-30 18:01:38 UTC")
      invoice5 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0, created_at: "1990-09-30 18:01:38 UTC")

      ItemInvoice.create!(item: item1, invoice: invoice1, quantity: 1, unit_price: item1.unit_price)
      ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      ItemInvoice.create!(item: item2, invoice: invoice2, quantity: 1, unit_price: item2.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice3, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice4, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice4, quantity: 1, unit_price: item3.unit_price)
      ItemInvoice.create!(item: item3, invoice: invoice5, quantity: 1, unit_price: item3.unit_price)
      Transaction.create!(invoice: invoice1, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice2, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice3, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 1)
      Transaction.create!(invoice: invoice4, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      Transaction.create!(invoice: invoice5, credit_card_number: '222222222', credit_card_expiration_date: nil, result: 0)
      
      start_date = '1990-02-01'
      end_date = '1990-07-01'
      expect(Merchant.revenue_date_range(start_date, end_date)).to eq(7.5)
    end
  end
end
