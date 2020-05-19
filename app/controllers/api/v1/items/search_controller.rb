class Api::V1::Items::SearchController < ApplicationController
  def index
    @items = Item.where(nil)
    @items = @items.filter_by_name(params[:name]) if params[:name]
    @items = @items.filter_by_description(params[:description]) if params[:description]
    @items = @items.filter_by_unit_price(params[:unit_price]) if params[:unit_price]
    @items = @items.filter_by_merchant_id(params[:merchant_id]) if params[:merchant_id]
    render json: ItemSerializer.new(@items)
  end

  def show
    @item = Item.where(nil)
    @item = @item.filter_by_name(params[:name]) if params[:name]
    @item = @item.filter_by_description(params[:description]) if params[:description]
    @item = @item.filter_by_unit_price(params[:unit_price]) if params[:unit_price]
    @item = @item.filter_by_merchant_id(params[:merchant_id]) if params[:merchant_id]
    render json: ItemSerializer.new(@item.first)
  end
end