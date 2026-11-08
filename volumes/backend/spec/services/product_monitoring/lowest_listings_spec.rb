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
end
