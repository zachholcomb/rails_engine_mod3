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
end