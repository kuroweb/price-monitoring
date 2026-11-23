require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Janpara::ListPage::Syncer do
  let(:setting) { create(:product_monitoring_crawl_setting) }
  let(:listings) { [] }
  let(:complete) { true }

  before do
    allow(ProductMonitoring::Crawling::Janpara::ListPage::Crawler).to receive(:call) do
      { listings: listings.map { |listing| listing.merge(platform: "janpara") }, complete: }
    end
  end

  def listing(id, **attributes)
    create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "janpara",
                                             external_id: id, name: "Phone",
                                             **attributes)
  end

  it "一覧で価格のない売り切れの出品をすぐ売り切れにし、日時と他サイトは変えないこと" do
    updated_at = 1.hour.ago.change(usec: 0)
    saved = listing("ITMCODE=313448", sold: false, updated_at:)
    # 設定内で external_id は一意なので、別サイトの同じ external_id は別の設定の行で用意する
    other = create(:product_monitoring_crawl_result, platform: "iosys", external_id: "ITMCODE=313448", sold: false)
    listings << { external_id: "ITMCODE=313448", name: "Phone", price: nil, sold: true }

    described_class.call(crawl_setting: setting)

    expect(saved.reload).to have_attributes(sold: true, sold_at: nil, updated_at:, recency_at: nil)
    expect(other.reload.sold).to be false
  end

  it "一覧から消えた古い出品を売り切れにし、価格がなくても一覧にある出品と他サイトは変えないこと" do
    updated_at = 4.hours.ago.change(usec: 0)
    missing = listing("jp-missing", sold: false, updated_at:)
    unpriced = listing("jp-unpriced", sold: false, updated_at:)
    other = create(:product_monitoring_crawl_result, crawl_setting: setting, platform: "iosys",
                                                     external_id: "iosys-kept",
                                                     name: "Phone", sold: false, updated_at:)
    listings << { external_id: "jp-unpriced", name: "Phone", price: nil, sold: false,
                  product_url: "https://www.janpara.co.jp/sale/search/detail/?ITMCODE=1" }

    described_class.call(crawl_setting: setting)

    expect(missing.reload).to have_attributes(sold: true, sold_at: nil, recency_at: nil)
    expect(missing.updated_at).to be_within(1.second).of(updated_at)
    expect(unpriced.reload.sold).to be false
    expect(other.reload.sold).to be false
  end

  it "最終更新から3時間未満の出品は売り切れにしないこと" do
    saved = listing("jp-recent", sold: false, updated_at: 2.hours.ago)
    described_class.call(crawl_setting: setting)
    expect(saved.reload.sold).to be false
  end

  it "一覧にある出品は売り切れでも販売中に戻し、売れた日は保つこと" do
    sold_at = 2.days.ago.change(usec: 0)
    saved = listing("jp-visible", sold: true, sold_at:, updated_at: 1.hour.ago)
    listings << { external_id: "jp-visible", name: "Phone blue", price: 100, sold: false,
                  product_url: "https://www.janpara.co.jp/sale/search/detail/?SRCODE=1" }

    described_class.call(crawl_setting: setting)

    expect(saved.reload).to have_attributes(sold: false, sold_at:, recency_at: saved.created_at)
  end

  it "同じ出品が両方の状態で返る場合は販売中を優先すること" do
    saved = listing("jp-both", sold: true)
    listings << { external_id: "jp-both", name: "Phone", price: nil, sold: true }
    listings << { external_id: "jp-both", name: "Phone", price: nil, sold: false }

    described_class.call(crawl_setting: setting)

    expect(saved.reload.sold).to be false
  end

  context "一覧を最後まで取得できなかったとき" do
    let(:complete) { false }

    it "一覧から消えた出品は売り切れにせず、一覧の売り切れ表示は反映すること" do
      missing = listing("jp-missing", sold: false, updated_at: 4.hours.ago)
      visible = listing("jp-visible", sold: false, updated_at: 4.hours.ago)
      listings << { external_id: "jp-visible", name: "Phone", price: nil, sold: true }

      described_class.call(crawl_setting: setting)

      expect(missing.reload.sold).to be false
      expect(visible.reload.sold).to be true
    end
  end
end
