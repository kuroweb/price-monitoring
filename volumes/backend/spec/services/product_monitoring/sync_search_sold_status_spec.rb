require "rails_helper"

RSpec.describe ProductMonitoring::SyncSearchSoldStatus do
  let(:setting) { create(:product_crawl_setting) }
  let(:sources) { [{ platform: "janpara", status: "succeeded" }] }
  let(:results) { [] }

  it "完全な検索から消えた古い出品を売り切れにする" do
    listing = create(:product_crawl_result, product_crawl_setting: setting, platform: "janpara",
                                            sold: false, updated_at: 4.hours.ago)

    described_class.call(product_crawl_setting: setting, crawled: { sources:, results: }, platform: "janpara")

    expect(listing.reload.sold).to be true
  end

  it "取得元が失敗した場合、一覧にある売り切れを反映しつつ消えた出品は維持する" do
    sources << { platform: "janpara", status: "failed" }
    missing = create(:product_crawl_result, product_crawl_setting: setting, platform: "janpara",
                                            sold: false, updated_at: 4.hours.ago)
    visible = create(:product_crawl_result, product_crawl_setting: setting, platform: "janpara",
                                            sold: false, updated_at: 4.hours.ago)
    results << { platform: "janpara", external_id: visible.external_id, price: nil, sold: true }

    described_class.call(product_crawl_setting: setting, crawled: { sources:, results: }, platform: "janpara")

    expect(missing.reload.sold).to be false
    expect(visible.reload.sold).to be true
  end

  it "同じ出品が両方の状態で返る場合は販売中を優先する" do
    listing = create(:product_crawl_result, product_crawl_setting: setting, platform: "janpara", sold: true)
    results << { platform: "janpara", external_id: listing.external_id, sold: true }
    results << { platform: "janpara", external_id: listing.external_id, sold: false }

    described_class.call(product_crawl_setting: setting, crawled: { sources:, results: }, platform: "janpara")

    expect(listing.reload.sold).to be false
  end
end
