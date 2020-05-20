class Api::V1::RevenueController < ApplicationController
  def index
    @revenue = Merchant.revenue_date_range(params[:start], params[:end])
    render '/revenue/index.json'
  end

  def show
    @revenue = Merchant.revenue(params[:id])
    render  '/revenue/show.json'
  end
end