require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 20)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(20)
  end

  it "can get one merchant by id" do
    merchant = create(:merchant)
    id = merchant.id
    get "/api/v1/merchants/#{id}"

    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(merchant.name) 
    response_id = merchant_response['data']['id'].to_i
    expect(response_id).to eq(id)
  end

  it 'can create a new merchant' do
    merchant_params = {
      'name': 'GoNuts for DoNuts'
    }

    post '/api/v1/merchants', params: { merchant: merchant_params }
    merchant = Merchant.last
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq('GoNuts for DoNuts') 
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it 'can update an existing merchant' do
    merchant = create(:merchant)
    id = merchant.id
    merchant_params = { 'name': 'Orange' }

    put "/api/v1/merchants/#{id}", params:{ merchant: merchant_params }
    updated_merchant = Merchant.last
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq('Orange') 
    expect(merchant.name).to_not eq(updated_merchant.name)
    expect(updated_merchant.name).to eq(merchant_params[:name])
  end

  it 'can delete an existing merchant' do
    merchant = create(:merchant)
    id = merchant.id

    expect{delete "/api/v1/merchants/#{id}"}.to change(Merchant, :count).by(-1)
    merchant_response = JSON.parse(response.body)
    
    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(merchant.name)
    expect{Merchant.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can return that merchants items' do
    merchant = create(:merchant)
    merchant2 = create(:merchant)

    10.times do 
      create(:item, merchant_id: merchant.id)
    end

    10.times do 
      create(:item, merchant_id: merchant2.id)
    end

    get "/api/v1/merchants/#{merchant.id}/items"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data'].count).to eq(10)
  end

  it 'can find merchant by name' do
    merchant = Merchant.create(name: "Pied Piper")
    name = "Pied Piper"

    get "/api/v1/merchants/find?name=#{name}"
    merchant_response = JSON.parse(response.body)
  
    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(name)

    partial_name = "pie"
    get "/api/v1/merchants/find?name=#{partial_name}"
    merchant_response2 = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response2['data']['attributes']['name']).to eq(name)

    no_name = 'McDonalds'
    get "/api/v1/merchants/find?name=#{no_name}"
    merchant_response3 = JSON.parse(response.body)
    
    expect(response).to be_successful
    expect(merchant_response3['data']).to eq(nil)
  end

  it "can find merchant by created_at" do
    merchant = Merchant.create(name: "Applebees", created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    merchant4 = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(merchant.name)
  end

  it "can find merchant by updated_at" do
    merchant = Merchant.create(name: "Applebees", created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    merchant4 = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['name']).to eq(merchant.name)
  end

  it "can find all merchant by string query" do
    merchant = Merchant.create(name: 'Apple')
    merchant2 = Merchant.create(name: 'Applebees')
    merchant3 = Merchant.create(name: 'Crabapple for you')
    merchant4 = create(:merchant)
    merchant5 = create(:merchant)
    merchant6 = create(:merchant)

    get "/api/v1/merchants/find_all?name=apple"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data'].count).to eq(3)
  end
end