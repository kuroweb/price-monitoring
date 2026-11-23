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

    after(:build) do |result|
      next if result.recency_at

      result.recency_at = if result.sold == true
                            result.sold_at
                          else
                            result.created_at || Time.current
                          end
    end
  end
end
