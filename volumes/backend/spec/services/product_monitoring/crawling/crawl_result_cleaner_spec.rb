require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::CrawlResultCleaner do
  let(:crawl_setting) do
    create(:product_monitoring_crawl_setting, required_keywords: ["phone"], negative_keywords: ["case"],
                                              min_price: 100, max_price: 1000)
  end

  it "条件に一致しない結果を除外済みの行も含めて削除し一致する結果を残すこと" do
    kept = create(:product_monitoring_crawl_result, crawl_setting:, name: "Phone blue", price: 500)
    create(:product_monitoring_crawl_result, crawl_setting:, name: "Tablet", price: 500)
    create(:product_monitoring_crawl_result, crawl_setting:, name: "Phone case", price: 500)
    create(:product_monitoring_crawl_result, crawl_setting:, name: "Phone cheap", price: 99)
    create(:product_monitoring_crawl_result, crawl_setting:, name: "Phone rich", price: 1001)
    create(:product_monitoring_crawl_result, crawl_setting:, name: "Tablet", price: 500, excluded_at: Time.current)
    described_class.call(crawl_setting:)
    expect(crawl_setting.crawl_results.pluck(:id)).to eq([kept.id])
  end

  it "他の収集設定の収集結果を削除しないこと" do
    other = create(:product_monitoring_crawl_result, name: "Tablet")
    described_class.call(crawl_setting:)
    expect(ProductMonitoring::CrawlResult.exists?(other.id)).to be(true)
  end
end
