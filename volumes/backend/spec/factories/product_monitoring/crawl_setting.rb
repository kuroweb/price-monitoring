FactoryBot.define do
  factory :product_monitoring_crawl_setting, class: "ProductMonitoring::CrawlSetting" do
    name        { "name" }
    enabled     { true }
    search_urls { ["https://iosys.co.jp/items?q=phone"] }
  end
end
