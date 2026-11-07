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

  it "saves auction prices and dates without losing an existing sale" do
    bought_date = 2.days.ago.change(usec: 0)
    end_date = 1.day.from_now.change(usec: 0)
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: true,
                                            bought_date:)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, buyout_price: 200, end_date:,
        product_url: "https://iosys.co.jp/items/a", sold: false }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload).to have_attributes(sold: true, bought_date:, buyout_price: 200, end_date:)
  end

  it "records the sale date from a closed auction listing" do
    bought_date = 2.days.ago.change(usec: 0)
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: false,
                                            buyout_price: 200)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, end_date: bought_date, bought_date:,
        product_url: "https://iosys.co.jp/items/a", sold: true }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload).to have_attributes(sold: true, bought_date:, end_date: bought_date, buyout_price: 200)
  end

  it "batches auction price and sale date updates across listings" do
    bought_date = 2.days.ago.change(usec: 0)
    listings = %w[a b c].map do |id|
      create(:product_crawl_result, product_crawl_setting:, external_id: id, name: "Phone old", sold: false)
    end
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return(
      %w[a b c].map do |id|
        { external_id: id, name: "Phone blue", price: 100, buyout_price: 200, bought_date:,
          product_url: "https://iosys.co.jp/items/#{id}", sold: true }
      end
    )
    statements = []
    subscriber = lambda do |_name, _start, _finish, _id, payload|
      statements << payload[:sql] if payload[:sql].match?(/\AUPDATE .*product_crawl_results/i)
    end
    ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.call(product_crawl_setting:)
    end
    expect(listings.map { |listing| listing.reload.attributes.values_at("buyout_price", "bought_date") })
      .to all(eq([200, bought_date]))
    expect(statements.count { |sql| sql.match?(/SET .*bought_date/i) }).to eq(1)
    expect(statements.count { |sql| sql.match?(/SET .*buyout_price/i) }).to eq(0)
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

    it "enqueues Yahoo missing and newly sold listings with their platform" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "yahoo_fleamarket",
                                    external_id: "missing-yahoo", sold: false, updated_at: 4.hours.ago)
      results << { platform: "yahoo_fleamarket", external_id: "sold-yahoo", reasons: [], price: 100, name: "Phone",
                   product_url: "https://paypayfleamarket.yahoo.co.jp/item/sold-yahoo", sold: true }
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("missing-yahoo", "yahoo_fleamarket")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("sold-yahoo", "yahoo_fleamarket")
    end

    it "enqueues missing and undated sold listings, but not visible or iosys listings" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false,
                                    updated_at: 4.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "undated", sold: true,
                                    updated_at: 4.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "iosys", external_id: "iosys", sold: false)
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("missing")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("undated")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("visible")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("iosys")
    end

    it "waits three hours before rechecking missing available listings" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "recent", sold: false,
                                    updated_at: 2.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "old", sold: false,
                                    updated_at: 4.hours.ago)
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("recent")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("old")
    end

    it "waits three hours before rechecking undated sold listings" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "recent", sold: true,
                                    updated_at: 2.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "old", sold: true,
                                    updated_at: 4.hours.ago)
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("recent")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("old")
    end

    it "immediately checks newly discovered and newly sold listings" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "changed", sold: false)
      %w[new changed].each do |id|
        results << { platform: "mercari", external_id: id, reasons: [], price: 100, name: "Phone",
                     product_url: "https://jp.mercari.com/item/#{id}", sold: true }
      end
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("new")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("changed")
    end

    it "does not enqueue missing listings when any source fails" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false,
                                    updated_at: 4.hours.ago)
      sources << { status: "failed" }
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async)
    end

    it "limits detail jobs in oldest order" do
      stub_const("ProductCrawlSettings::SyncResults::MAX_DETAIL_JOBS", 2)
      allow(Rails.logger).to receive(:info).and_call_original
      3.times do |n|
        create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "m#{n}", sold: false,
                                      updated_at: (3 - n).days.ago)
      end
      described_class.call(product_crawl_setting: setting)
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("m0")
      expect(ProductCrawlSettings::SyncDetailJob).to have_received(:perform_async).with("m1")
      expect(ProductCrawlSettings::SyncDetailJob).not_to have_received(:perform_async).with("m2")
      expect(Rails.logger).to have_received(:info).with("Product crawl detail candidates: setting_id=#{setting.id} candidates=3 enqueued=2")
    end
  end
end
