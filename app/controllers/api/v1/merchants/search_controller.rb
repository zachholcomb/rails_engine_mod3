class Api::V1::Merchants::SearchController < ApplicationController
  def index
    @merchant = Merchant.where(nil)
    @merchant = @merchant.filter_by_name(params[:name]) if params[:name].present?
    @merchant = @merchant.filter_by_created_at(params[:created_at]) if params[:created_at].present?
    @merchant = @merchant.filter_by_updated_at(params[:updated_at]) if params[:updated_at].present?
    render json: MerchantSerializer.new(@merchant)
  end

  def show
    @merchant = Merchant.where(nil)
    @merchant = @merchant.filter_by_name(params[:name]) if params[:name].present?
    @merchant = @merchant.filter_by_created_at(params[:created_at]) if params[:created_at].present?
    @merchant = @merchant.filter_by_updated_at(params[:updated_at]) if params[:updated_at].present?
    render json: MerchantSerializer.new(@merchant.first)
  end
end