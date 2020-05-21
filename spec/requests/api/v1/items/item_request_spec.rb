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
    post "/api/v1/items", params: item_params
    item = Item.last
    item_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(Item.count).to eq(21)
    expect(item.merchant).to eq(@merchant)

    expect(item_response['data']['attributes']['name']).to eq(item.name)
    expect(item_response['data']['attributes']['description']).to eq(item.description)
    expect(item_response['data']['attributes']['unit_price']).to eq(item.unit_price)
    expect(item_response['data']['attributes']['merchant_id']).to eq(item.merchant.id)
  end

  it 'can update an item' do
    item_params = {
      name: 'Slingshot',
      description: "It's cool!",
      unit_price: 299.99,
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

  it 'can get merchant associated with an item' do
    item = Item.last
    merchant_expectations = item.merchant.name

    get "/api/v1/items/#{item.id}/merchant"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(merchant_expectations)
  end

  it "can return item by string query" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find?name=frisbee"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data']['attributes']['name']).to eq(item.name)

    get "/api/v1/items/find?name=fris"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data']['attributes']['name']).to eq(item.name)
  end

  it "can return item by partial description" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find?description=flying off the shelves"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data']['attributes']['name']).to eq(item.name)

    get "/api/v1/items/find?description=shelves"
    merchant_response2 = JSON.parse(response.body)
    expect(merchant_response2['data']['attributes']['name']).to eq(item.name)
  end

  it "can return item by unit price" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find?unit_price=20.99"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data']['attributes']['name']).to eq(item.name)
  end

  it "can return item by merchant_id" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find?merchant_id=#{merchant.id}"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data']['attributes']['name']).to eq(item.name)
  end

  it "can return all items matching a query string" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )
    item2 = Item.create(name: 'Frisbee Freakout',
                    description: 'Flying off the shelves',
                    unit_price: 20.99,
                    merchant: merchant
    )
    item3 = Item.create(name: 'Frisbee Factory',
                    description: 'Flying off the shelves',
                    unit_price: 20.99,
                    merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find_all?name=frisbee"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data'].count).to eq(3)
    expect(merchant_response['data'][0]['attributes']['name']).to eq(item.name)
  end

  it "can return all items whose description match a query string" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )
    item2 = Item.create(name: 'Frisbee Freakout',
                    description: 'Watch these babies fly!',
                    unit_price: 20.99,
                    merchant: merchant
    )
    item3 = Item.create(name: 'Frisbee Factory',
                    description: 'They fly good!',
                    unit_price: 20.99,
                    merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find_all?description=fly"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data'].count).to eq(3)
    expect(merchant_response['data'][0]['attributes']['name']).to eq(item.name)
  end

  it "can return all merchants whose unit_price matches a query" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )
    item2 = Item.create(name: 'Frisbee Freakout',
                    description: 'Watch these babies fly!',
                    unit_price: 10.99,
                    merchant: merchant
    )
    item3 = Item.create(name: 'Frisbee Factory',
                    description: 'They fly good!',
                    unit_price: 20.99,
                    merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find_all?unit_price=20.99"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data'].count).to eq(2)
    expect(merchant_response['data'][0]['attributes']['name']).to eq(item.name)
  end

  it "can return all merchants whose unit_price matches a query" do
    merchant = create(:merchant)
    merchant2 = create(:merchant)
    item = Item.create(name: 'Frisbee',
                        description: 'Flying off the shelves',
                        unit_price: 20.99,
                        merchant: merchant
    )
    item2 = Item.create(name: 'Frisbee Freakout',
                    description: 'Watch these babies fly!',
                    unit_price: 10.99,
                    merchant: merchant
    )
    item3 = Item.create(name: 'Frisbee Factory',
                    description: 'They fly good!',
                    unit_price: 20.99,
                    merchant: merchant
    )

    5.times do
      create(:item, merchant: merchant2)
    end

    get "/api/v1/items/find_all?merchant_id=#{merchant2.id}"
    merchant_response = JSON.parse(response.body)
    expect(merchant_response['data'].count).to eq(5)
  end
end