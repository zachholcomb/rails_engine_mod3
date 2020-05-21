class Api::V1::MerchantRevenueController < ApplicationController
  def show
    value = Merchant.revenue(params[:id])
    render json: RevenueSerializer.new(Revenue.new(value))
  end
end