FactoryBot.define do
  factory :customer do
    first_name { Faker::TvShows::SiliconValley.character }
    last_name { Faker::TvShows::Seinfeld.character }
  end
end
