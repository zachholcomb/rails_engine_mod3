class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.filter(filtering_params(params))
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.filter(filtering_params(params)).first
    render json: ItemSerializer.new(item)
  end

  private 

  def filtering_params(params)
    params.slice(:name, :description, :unit_price, :merchant_id)
  end
end