require "rails_helper"

RSpec.describe ProductCrawlSettings::SyncResults do
  let(:product_crawl_setting) { create(:product_crawl_setting, required_keywords: ["phone"]) }

  before do
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a",
        thumbnail_url: "https://iosys.co.jp/a.jpg" },
      { external_id: "b", name: "Case", price: 100, product_url: "https://iosys.co.jp/items/b" },
      { external_id: "excluded", name: "Phone red", price: 300, product_url: "https://iosys.co.jp/items/excluded" }
    ])
  end

  it "saves only accepted listings with their platform" do
    described_class.call(product_crawl_setting:)
    results = product_crawl_setting.product_crawl_results
    expect(results.pluck(:external_id)).to contain_exactly("a", "excluded")
    expect(results.find_by(external_id: "a")).to have_attributes(
      platform: "iosys", product_url: "https://iosys.co.jp/items/a", price: 100, thumbnail_url: "https://iosys.co.jp/a.jpg"
    )
  end

  it "keeps an excluded listing excluded while updating its price" do
    excluded_at = 1.day.ago.change(usec: 0)
    create(:product_crawl_result, product_crawl_setting:, external_id: "excluded", name: "Phone red", price: 100,
                                  excluded_at:)
    result = described_class.call(product_crawl_setting:)
    expect(result[:results].find { |row| row[:external_id] == "excluded" }).to include(accepted: false)
    expect(product_crawl_setting.product_crawl_results.find_by(external_id: "excluded")).to have_attributes(
      price: 300, excluded_at:
    )
  end

  it "keeps listings missing from the latest crawl and removes ones that no longer match" do
    kept = create(:product_crawl_result, product_crawl_setting:, external_id: "sold", name: "Phone sold")
    create(:product_crawl_result, product_crawl_setting:, external_id: "unmatched", name: "Case")
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", "excluded", kept.external_id)
  end

  it "updates an existing listing instead of duplicating it" do
    create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.where(external_id: "a").sole).to have_attributes(
      name: "Phone blue", price: 100
    )
  end

  it "preserves a sold listing and its bought date when the listing says it is available" do
    bought_date = 2.days.ago.beginning_of_day
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: true,
                                            bought_date:)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a", sold: false }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload).to have_attributes(sold: true, bought_date:)
  end

  it "records a sold marker on an existing listing" do
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: false)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a", sold: true }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload.sold).to be true
  end

  it "skips listings without a price while retaining existing rows and accepting zero" do
    existing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone new", price: nil, product_url: "https://iosys.co.jp/items/a" },
      { external_id: "missing", name: "Phone", price: nil, product_url: "https://iosys.co.jp/items/missing" },
      { external_id: "free", name: "Phone", price: 0, product_url: "https://iosys.co.jp/items/free" }
    ])
    described_class.call(product_crawl_setting:)
    expect(existing.reload).to have_attributes(name: "Phone old", price: 50)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", "free")
  end

  describe ".call detail enqueue" do
    let(:setting) { create(:product_crawl_setting) }
    let(:sources) { [{ status: "succeeded" }] }
    let(:results) { [{ platform: "mercari", external_id: "visible", reasons: [], price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/visible", sold: false }] }

    before do
      allow(ProductMonitoring::Crawler).to receive(:call).and_return(sources: sources, results: results)
      allow(ProductCrawlSettings::SyncDetailJob).to receive(:perform_async)
    end

    it "enqueues missing and undated sold listings, but not visible or iosys listings" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "undated", sold: true)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "iosys", external_id: "iosys", sold: false)
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("missing")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("undated")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("visible")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("iosys")
    end

    it "does not enqueue missing listings when any source fails" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false)
      sources << { status: "failed" }
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async)
    end

    it "limits detail jobs in oldest order" do
      stub_const("ProductCrawlSettings::SyncResults::MAX_DETAIL_JOBS", 2)
      3.times do |n|
        create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "m#{n}", sold: false,
                                      updated_at: (3 - n).days.ago)
      end
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("m0")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("m1")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("m2")
    end
  end
end
