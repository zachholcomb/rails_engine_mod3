class Api::V1::RevenueController < ApplicationController
  def index
    @value = Merchant.revenue_date_range(params[:start], params[:end])
    render json: RevenueSerializer.new(Revenue.new(@value))
  end
end