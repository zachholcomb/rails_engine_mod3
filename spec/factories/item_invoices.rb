FactoryBot.define do
  factory :item_invoice do
    item { nil }
    invoice { nil }
    quantity { 1 }
    unit_price { 1.5 }
  end
end
