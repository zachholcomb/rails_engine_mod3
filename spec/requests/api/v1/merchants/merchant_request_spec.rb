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

  it "can find a merchant with multiple queries" do
    merchant = Merchant.create(name: 'Orange', created_at: "2020-03-22 18:01:38 UTC", updated_at: "2020-03-23 19:01:38 UTC")
    merchant2 = Merchant.create(name: 'Orange Julius')
    merchant3 = Merchant.create(name: 'Crabapple for you')
    merchant4 = create(:merchant)
    merchant5 = create(:merchant)
    merchant6 = create(:merchant)

    get "/api/v1/merchants/find?name=orange&created_at=#{merchant.created_at}"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['id']).to eq(merchant.id)
  end

  it "can get merchants with most revenue" do
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

    get "/api/v1/merchants/most_revenue?quantity=2"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data'].count).to eq(2)
    expect(merchant_response['data'][0]['attributes']['name']).to eq(merchant3.name)
    expect(merchant_response['data'][1]['attributes']['name']).to eq(merchant2.name)
  end

  it 'can get merchants with most items' do
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

    get "/api/v1/merchants/most_items?quantity=2"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data'].count).to eq(2)
    expect(merchant_response['data'][0]['attributes']['name']).to eq(merchant2.name)
    expect(merchant_response['data'][1]['attributes']['name']).to eq(merchant3.name)
  end

  it 'can get revenue for one merchant' do
    customer1 = create(:customer)
    customer2 = create(:customer)
    merchant1 = create(:merchant)

    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    item3 = create(:item, merchant: merchant1)

    invoice1 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0)
    invoice2 = Invoice.create!(customer: customer2, merchant: merchant1, status: 0)
    invoice3 = Invoice.create!(customer: customer1, merchant: merchant1, status: 0)
    invoice4 = Invoice.create!(customer: customer2, merchant: merchant1, status: 0)
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
    
    get "/api/v1/merchants/#{merchant1.id}/revenue"
    merchant_response = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant_response['data']['attributes']['revenue']).to eq(9.0)
  end
end