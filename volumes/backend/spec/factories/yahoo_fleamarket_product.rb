FactoryBot.define do
  factory :yahoo_fleamarket_product do
    association :product, factory: :product, strategy: :create

    sequence :external_id do |n|
      "external_id_#{n}"
    end
    seller_id     { "seller_id" }
    name          { "name" }
    thumbnail_url { "https://example.com" }
    price         { 10_000 }
    published     { true }
    bought_date   { nil }
  end
end
