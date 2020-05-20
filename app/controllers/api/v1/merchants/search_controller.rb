class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.filter(filtering_params(params))
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.filter(filtering_params(params)).first
    render json: MerchantSerializer.new(merchant)
  end

  private 

  def filtering_params(params)
    params.slice(:name, :created_at, :updated_at)
  end
end