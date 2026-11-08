require "rails_helper"

RSpec.describe ProductMonitoring::CleanseCrawlResults do
  let(:product_crawl_setting) do
    create(:product_crawl_setting, required_keywords: ["phone"], exclude_keywords: ["case"],
                                   min_price: 100, max_price: 1000)
  end

  it "条件に一致しない結果を除外済みの行も含めて削除し一致する結果を残すこと" do
    kept = create(:product_crawl_result, product_crawl_setting:, name: "Phone blue", price: 500)
    create(:product_crawl_result, product_crawl_setting:, name: "Tablet", price: 500)
    create(:product_crawl_result, product_crawl_setting:, name: "Phone case", price: 500)
    create(:product_crawl_result, product_crawl_setting:, name: "Phone cheap", price: 99)
    create(:product_crawl_result, product_crawl_setting:, name: "Phone rich", price: 1001)
    create(:product_crawl_result, product_crawl_setting:, name: "Tablet", price: 500, excluded_at: Time.current)
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.pluck(:id)).to eq([kept.id])
  end

  it "他の商品計測設定の結果を削除しないこと" do
    other = create(:product_crawl_result, name: "Tablet")
    described_class.call(product_crawl_setting:)
    expect(ProductCrawlResult.exists?(other.id)).to be(true)
  end
end
