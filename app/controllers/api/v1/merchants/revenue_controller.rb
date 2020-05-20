class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end
end