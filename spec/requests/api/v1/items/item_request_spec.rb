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

  it 'can create an item' do
    expect(Item.count).to eq(20)

    item_params = {
      name: 'Slingshot',
      description: "It's cool!",
      unit_price: 29.99,
      merchant_id: @merchant.id
    }
    post "/api/v1/items", params: { item: item_params }
    item = Item.last
    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(Item.count).to eq(21)

    expect(item_response['data']['attributes']['name']).to eq(item.name)
    expect(item_response['data']['attributes']['description']).to eq(item.description)
    expect(item_response['data']['attributes']['unit_price']).to eq(item.unit_price)
    expect(item_response['data']['attributes']['merchant_id']).to eq(item.merchant.id)
  end

  it 'can update an item' do
    item_params = {
      name: 'Slingshot',
      description: "It's cool!",
      unit_price: 29.99,
      merchant_id: @merchant.id
    }
    item = Item.last

    put "/api/v1/items/#{item.id}", params: { item: item_params }
    item_response = JSON.parse(response.body)
    updated_item = Item.last

    expect(response).to be_successful
    expect(item_response['data']['attributes']['name']).to_not eq(item.name)
    expect(item_response['data']['attributes']['description']).to_not eq(item.description)
    expect(item_response['data']['attributes']['unit_price']).to_not eq(item.unit_price)
    expect(item_response['data']['attributes']['merchant_id']).to_not eq(item.merchant.id)
    expect(item_response['data']['attributes']['name']).to eq(updated_item.name)
    expect(item_response['data']['attributes']['description']).to eq(updated_item.description)
    expect(item_response['data']['attributes']['unit_price']).to eq(updated_item.unit_price)
    expect(item_response['data']['attributes']['merchant_id']).to eq(updated_item.merchant.id)
  end

  it 'can delete and item' do
    item = Item.last

    expect{delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)
    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item_response['data']['attributes']['name']).to eq(item.name)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end