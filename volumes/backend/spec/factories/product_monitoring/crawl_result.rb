FactoryBot.define do
  factory :product_monitoring_crawl_result, class: "ProductMonitoring::CrawlResult" do
    association :crawl_setting, factory: :product_monitoring_crawl_setting, strategy: :create

    platform { "iosys" }
    sequence :external_id do |n|
      "external_id_#{n}"
    end
    name        { "name" }
    product_url { "https://example.com" }
    price       { 10_000 }
    sold        { nil }
    sold_at { nil }
  end
end
