FactoryBot.define do
  factory :yahoo_auction_crawl_setting do
    association :product, factory: :product, strategy: :create

    keyword     { "keyword" }
    category_id { nil }
    min_price   { 1000 }
    max_price   { 10_000 }
    enabled     { true }
  end
end
