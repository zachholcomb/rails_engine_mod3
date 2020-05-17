require 'rails_helper'

describe 'Items API' do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    
    10.times do 
      create(:item, merchant_id: @merchant.id)
    end

    10.times do
      create(:item, merchant_id: @merchant2.id)
    end
  end
  it 'sends a list of items' do

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items['data'].count).to eq(20)
  end

  it 'can get one item by id' do
    item = Item.last

    get "/api/v1/items/#{item.id}"
    
    expect(response).to be_successful
    item_response = JSON.parse(response.body)

    expect(item_response['data']['attributes']['name']).to eq(item.name)
    expect(item_response['data']['attributes']['description']).to eq(item.description)
    expect(item_response['data']['attributes']['unit_price']).to eq(item.unit_price)
    expect(item_response['data']['attributes']['merchant_id']).to eq(item.merchant.id)
  end
end