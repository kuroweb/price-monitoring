require "rails_helper"

RSpec.describe ProductMonitoring::WatchListings do
  it "複数バッチから条件に合う商品を価格とIDの順に重複なく返す" do
    stub_const("ProductMonitoring::LowestListings::BATCH_SIZE", 2)
    setting = ProductWatchSetting.create!(name: "phone", required_keywords: ["phone"])
    create(:product_crawl_result, name: "case", price: 50, sold: false)
    first = create(:product_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys", external_id: "one")
    create(:product_crawl_result, name: "phone", price: 100, sold: false, platform: "iosys", external_id: "one")
    other_platform = create(:product_crawl_result, name: "phone", price: 100, sold: false,
                                                   platform: "mercari", external_id: "one")
    higher = create(:product_crawl_result, name: "phone", price: 200, sold: false)

    expect(described_class.call(product_watch_setting: setting)).to eq([first, other_platform, higher])
  end

  it "8件に達した後の商品を条件判定しない" do
    setting = ProductWatchSetting.create!(name: "phone")
    expected = (1..8).map { |price| create(:product_crawl_result, price: price, sold: false) }
    later = create(:product_crawl_result, price: 9, sold: false)

    allow(ProductMonitoring::Filter).to receive(:call).and_call_original
    expect(described_class.call(product_watch_setting: setting)).to eq(expected)
    expect(ProductMonitoring::Filter).not_to have_received(:call).with(
      item: later.attributes.symbolize_keys, params: anything
    )
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductWatchSetting.create!(name: "phone", required_keywords: ["phone"])
    create(:product_crawl_result, name: "case", price: 100, sold: false)

    expect(described_class.call(product_watch_setting: setting)).to eq([])
  end
end
