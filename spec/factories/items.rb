FactoryBot.define do
  factory :item do
    name { Faker::TvShows::SiliconValley.invention }
    description { Faker::TvShows::RickAndMorty.quote }
    unit_price { 1.5 }
    merchant { nil }
  end
end
