require "rails_helper"

RSpec.describe ProductMonitoring::Search::MonitorCrawlResults do
  it "複数バッチから条件に合う商品を価格とIDの順に重複なく返す" do
    stub_const("ProductMonitoring::Search::MonitorCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 50, sold: false)
    first = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys",
                                                     external_id: "one")
    create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys",
                                             external_id: "one")
    other_platform = create(:product_monitoring_crawl_result, name: "phone", price: 100, sold: false,
                                                              platform: "mercari", external_id: "one")
    higher = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: false)

    expect(described_class.call(monitor: setting)).to eq([first, other_platform, higher])
  end

  it "8件に達した後の商品を条件判定しない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    expected = (1..8).map { |price| create(:product_monitoring_crawl_result, price: price, sold: false) }
    later = create(:product_monitoring_crawl_result, price: 9, sold: false)

    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original
    expect(described_class.call(monitor: setting)).to eq(expected)
    expect(matcher).not_to have_received(:call).with(monitor: setting, listing: later)
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)

    expect(described_class.call(monitor: setting)).to eq([])
  end
end
