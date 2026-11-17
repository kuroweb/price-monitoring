require "rails_helper"

RSpec.describe ProductMonitoring::Search::NewestCrawlResults do
  it "複数バッチから条件に合う商品を売り切れも含めて新着順に重複なく返す" do
    stub_const("ProductMonitoring::Search::NewestCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    oldest = create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false)
    other_platform = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false,
                                                              platform: "mercari", external_id: "one")
    create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys",
                                             external_id: "one")
    first = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: true, platform: "iosys",
                                                     external_id: "one")
    create(:product_monitoring_crawl_result, name: "case", price: 50, sold: false)
    create(:product_monitoring_crawl_result, name: "phone", price: 50, sold: false, excluded_at: Time.current)
    newest = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: nil)

    expect(described_class.call(monitor: setting)).to eq([newest, first, other_platform, oldest])
  end

  it "価格帯の上下限を含めて検索する" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", min_price: 100, max_price: 200)
    lower = create(:product_monitoring_crawl_result, price: 100, sold: true)
    create(:product_monitoring_crawl_result, price: 99, sold: false)
    upper = create(:product_monitoring_crawl_result, price: 200, sold: false)
    create(:product_monitoring_crawl_result, price: 201, sold: false)

    expect(described_class.call(monitor: setting)).to eq([upper, lower])
  end

  it "8件に達した後の商品を条件判定しない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    older = create(:product_monitoring_crawl_result, sold: false)
    expected = Array.new(8) { create(:product_monitoring_crawl_result, sold: true) }.reverse

    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original
    expect(described_class.call(monitor: setting)).to eq(expected)
    expect(matcher).not_to have_received(:call).with(monitor: setting, listing: older)
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)

    expect(described_class.call(monitor: setting)).to eq([])
  end
end
