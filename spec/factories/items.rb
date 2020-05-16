FactoryBot.define do
  factory :item do
    name { "" }
    description { "MyText" }
    unit_price { 1.5 }
    merchant { nil }
  end
end
