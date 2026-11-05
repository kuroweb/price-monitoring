FactoryBot.define do
  factory :product_crawl_result do
    association :product_crawl_setting, factory: :product_crawl_setting, strategy: :create

    platform { "iosys" }
    sequence :external_id do |n|
      "external_id_#{n}"
    end
    name        { "name" }
    product_url { "https://example.com" }
    price       { 10_000 }
    sold        { nil }
    bought_date { nil }
  end
end
