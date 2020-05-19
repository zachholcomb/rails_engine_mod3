require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :item_invoices }
    it { should have_many(:invoices).through(:item_invoices) } 
  end

  describe 'scopes' do
    before(:each) do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @item = Item.create(name: 'Frisbee',
                         description: 'Flying off the shelves',
                         unit_price: 20.99,
                         merchant: @merchant
      )

      5.times do
        create(:item, merchant: @merchant2)
      end

      10.times do
        create(:item, merchant: @merchant3)
      end
    end

    it "filter_by_name" do
      expect(Item.filter_by_name('Frisbee')).to eq([@item])
      expect(Item.filter_by_name('risbee')).to eq([@item])
    end

    it "filter_by_description" do
      expect(Item.filter_by_description('Flying off')).to eq([@item])
      expect(Item.filter_by_description('off the shelves')).to eq([@item])
    end

    it "filter_by_unit_price" do
      expect(Item.filter_by_unit_price(20.99)).to eq([@item])
    end

    it 'filter_by_merchant_id' do
      expect(Item.filter_by_merchant_id(@merchant.id)).to eq([@item])
    end
  end
end
