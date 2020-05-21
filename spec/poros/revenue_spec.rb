require 'rails_helper'

describe Revenue do
  it 'initializes with an idea of nil and a given revenue' do
    revenue_expectations = 6600000.000
    revenue = Revenue.new(revenue_expectations)
    
    expect(revenue.id).to eq(nil)
    expect(revenue.revenue).to eq(revenue_expectations)
  end
end