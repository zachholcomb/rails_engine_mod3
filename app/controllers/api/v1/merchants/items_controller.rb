class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchants = Merchant.most_items(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end
end