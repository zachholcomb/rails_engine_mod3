require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :item_invoices }
    it { should have_many(:invoices).through(:item_invoices) } 
  end
end
