FactoryBot.define do
  factory :product_crawl_setting do
    name        { "name" }
    enabled     { true }
    search_urls { ["https://iosys.co.jp/items?q=phone"] }
  end
end
