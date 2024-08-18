FactoryBot.define do
  factory :yahoo_auction_product do
    association :product, factory: :product, strategy: :create

    sequence :external_id do |n|
      "external_id_#{n}"
    end
    seller_id     { "seller_id" }
    name          { "name" }
    thumbnail_url { "https://example.com" }
    price         { 10_000 }
    buyout_price  { nil }
    published     { true }
    bought_date   { nil }
    end_date      { "2024-01-01 00:00:00 +0900" }
  end
end
