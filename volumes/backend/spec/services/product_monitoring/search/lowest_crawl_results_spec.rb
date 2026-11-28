require "rails_helper"

RSpec.describe ProductMonitoring::Search::LowestCrawlResults do
  it "価格順の複数バッチから条件に合う最安の全商品を返し、より高い商品は判定しない" do
    stub_const("ProductMonitoring::Search::LowestCrawlResults::BATCH_SIZE", 2)
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)
    first = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: false, external_id: "one")
    duplicate = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: false, external_id: "one")
    second = create(:product_monitoring_crawl_result, name: "phone", price: 200, sold: false, external_id: "two")
    expensive = create(:product_monitoring_crawl_result, name: "phone", price: 300, sold: false)

    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original
    expect(described_class.call(monitor: setting)).to eq([first, second])
    expect(matcher).to have_received(:call).exactly(4).times
    expect(matcher).not_to have_received(:call).with(monitor: setting, listing: expensive)
    expect(duplicate.id).not_to eq(first.id)
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", required_keywords: ["phone"])
    create(:product_monitoring_crawl_result, name: "case", price: 100, sold: false)
    expect(described_class.call(monitor: setting)).to eq([])
  end

  it "価格帯の上下限を含めて検索し、範囲外の商品を条件判定しない" do
    setting = ProductMonitoring::Monitor.create!(name: "phone", min_price: 100, max_price: 200)
    create(:product_monitoring_crawl_result, price: 99, sold: false)
    lower = create(:product_monitoring_crawl_result, price: 100, sold: false)
    create(:product_monitoring_crawl_result, price: 200, sold: false)
    create(:product_monitoring_crawl_result, price: 201, sold: false)

    matcher = ProductMonitoring::Monitor::Matcher
    allow(matcher).to receive(:call).and_call_original
    expect(described_class.call(monitor: setting)).to eq([lower])
    expect(matcher).to have_received(:call).once
  end

  it "価格の上限が0でも適用し、未指定なら制限しない" do
    free = create(:product_monitoring_crawl_result, price: 0, sold: false)
    paid = create(:product_monitoring_crawl_result, price: 1, sold: false)
    setting = ProductMonitoring::Monitor.create!(name: "phone", max_price: 0)

    expect(described_class.call(monitor: setting)).to eq([free])
    free.update!(sold: true)
    expect(described_class.call(monitor: setting)).to eq([])
    setting.update!(max_price: nil)
    expect(described_class.call(monitor: setting)).to eq([paid])
  end

  it "除外する出品者の出品を、出品者IDが不明な別の収集設定の同じ出品も含めて最安値から外すこと" do
    setting = ProductMonitoring::Monitor.create!(name: "phone")
    create(:product_monitoring_excluded_seller, platform: "mercari", seller_id: "Seller_1")
    create(:product_monitoring_crawl_result, platform: "mercari", external_id: "a", price: 100, sold: false)
    create(:product_monitoring_crawl_result, platform: "mercari", external_id: "a", price: 100, sold: false,
                                             seller_id: "Seller_1")
    unknown = create(:product_monitoring_crawl_result, platform: "mercari", external_id: "b", price: 200, sold: false)

    expect(described_class.call(monitor: setting)).to eq([unknown])
  end
end
