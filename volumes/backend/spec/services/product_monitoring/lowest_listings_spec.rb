require "rails_helper"

RSpec.describe ProductMonitoring::LowestListings do
  it "価格順の複数バッチから条件に合う最安の全商品を返し、より高い商品は判定しない" do
    stub_const("ProductMonitoring::LowestListings::BATCH_SIZE", 2)
    setting = ProductWatchSetting.create!(name: "phone", required_keywords: ["phone"])
    create(:product_crawl_result, name: "case", price: 100, sold: false)
    first = create(:product_crawl_result, name: "phone", price: 200, sold: false, external_id: "one")
    duplicate = create(:product_crawl_result, name: "phone", price: 200, sold: false, external_id: "one")
    second = create(:product_crawl_result, name: "phone", price: 200, sold: false, external_id: "two")
    expensive = create(:product_crawl_result, name: "phone", price: 300, sold: false)

    allow(ProductMonitoring::Filter).to receive(:call).and_call_original
    expect(described_class.call(product_watch_setting: setting)).to eq([first, second])
    expect(ProductMonitoring::Filter).to have_received(:call).exactly(4).times
    expect(ProductMonitoring::Filter).not_to have_received(:call).with(
      item: expensive.attributes.symbolize_keys, params: anything
    )
    expect(duplicate.id).not_to eq(first.id)
  end

  it "条件に合う商品がなければ空を返す" do
    setting = ProductWatchSetting.create!(name: "phone", required_keywords: ["phone"])
    create(:product_crawl_result, name: "case", price: 100, sold: false)
    expect(described_class.call(product_watch_setting: setting)).to eq([])
  end

  it "価格帯の上下限を含めて検索し、範囲外の商品を条件判定しない" do
    setting = ProductWatchSetting.create!(name: "phone", min_price: 100, max_price: 200)
    create(:product_crawl_result, price: 99, sold: false)
    lower = create(:product_crawl_result, price: 100, sold: false)
    upper = create(:product_crawl_result, price: 200, sold: false)
    create(:product_crawl_result, price: 201, sold: false)

    expect(described_class.candidates(described_class.filter_params(setting))).to contain_exactly(lower, upper)
    expect(described_class.call(product_watch_setting: setting)).to eq([lower])
  end

  it "価格の上限が0でも適用し、未指定なら制限しない" do
    free = create(:product_crawl_result, price: 0, sold: false)
    paid = create(:product_crawl_result, price: 1, sold: false)
    setting = ProductWatchSetting.create!(name: "phone", max_price: 0)

    expect(described_class.candidates(described_class.filter_params(setting))).to contain_exactly(free)
    setting.update!(max_price: nil)
    expect(described_class.candidates(described_class.filter_params(setting))).to contain_exactly(free, paid)
  end
end
