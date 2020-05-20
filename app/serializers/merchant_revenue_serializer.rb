class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue do |merchant|
    Merchant.revenue(merchant.id)
  end
end
