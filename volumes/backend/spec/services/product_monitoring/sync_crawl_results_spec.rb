require "rails_helper"

RSpec.describe ProductMonitoring::SyncCrawlResults do
  let(:product_crawl_setting) { create(:product_crawl_setting, required_keywords: ["phone"]) }

  before do
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a",
        thumbnail_url: "https://iosys.co.jp/a.jpg" },
      { external_id: "b", name: "Case", price: 100, product_url: "https://iosys.co.jp/items/b" },
      { external_id: "excluded", name: "Phone red", price: 300, product_url: "https://iosys.co.jp/items/excluded" }
    ])
  end

  it "既存の売却情報を保持してオークションの価格と日時を保存すること" do
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

  it "終了したオークションの出品から売却日時を記録すること" do
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

  it "出品のオークション価格と売却日時をまとめて更新すること" do
    dates = Array.new(4) { |n| (2.days.ago + n.minutes).change(usec: 0) }
    listings = %w[a b c].map do |id|
      create(:product_crawl_result, product_crawl_setting:, external_id: id, name: "Phone old", sold: false)
    end
    listings.first.update!(bought_date: 3.days.ago.change(usec: 0), buyout_price: 300)
    original_date = listings.first.bought_date
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return(
      %w[a b c d].each_with_index.map do |id, index|
        { external_id: id, name: "Phone blue", price: 100, buyout_price: (index.zero? ? nil : 200),
          bought_date: dates[index], end_date: dates[index],
          product_url: "https://iosys.co.jp/items/#{id}", sold: true }
      end
    )
    statements = []
    subscriber = lambda do |_name, _start, _finish, _id, payload|
      statements << payload[:sql] if payload[:sql].match?(/\A(?:UPDATE|INSERT INTO) .*product_crawl_results/i)
    end
    ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.call(product_crawl_setting:)
    end
    expect(listings.first.reload).to have_attributes(buyout_price: 300, bought_date: original_date)
    expect(listings[1].reload).to have_attributes(buyout_price: 200, bought_date: dates[1])
    expect(listings[2].reload).to have_attributes(buyout_price: 200, bought_date: dates[2])
    expect(product_crawl_setting.product_crawl_results.find_by!(external_id: "d"))
      .to have_attributes(buyout_price: 200, bought_date: dates[3])
    expect(statements.count { |sql| sql.match?(/\AINSERT/i) }).to eq(1)
    expect(statements.count { |sql| sql.match?(/\AUPDATE/i) }).to eq(1)
  end

  it "条件に合う出品だけをプラットフォームとともに保存すること" do
    described_class.call(product_crawl_setting:)
    results = product_crawl_setting.product_crawl_results
    expect(results.pluck(:external_id)).to contain_exactly("a", "excluded")
    expect(results.find_by(external_id: "a")).to have_attributes(
      platform: "iosys", product_url: "https://iosys.co.jp/items/a", price: 100, thumbnail_url: "https://iosys.co.jp/a.jpg"
    )
  end

  it "除外済み出品の除外状態を保って価格を更新すること" do
    excluded_at = 1.day.ago.change(usec: 0)
    create(:product_crawl_result, product_crawl_setting:, external_id: "excluded", name: "Phone red", price: 100,
                                  excluded_at:)
    result = described_class.call(product_crawl_setting:)
    expect(result[:results].find { |row| row[:external_id] == "excluded" }).to include(accepted: false)
    expect(product_crawl_setting.product_crawl_results.find_by(external_id: "excluded")).to have_attributes(
      price: 300, excluded_at:
    )
  end

  it "最新のクロールにない出品を保持し条件に合わなくなった出品を削除すること" do
    kept = create(:product_crawl_result, product_crawl_setting:, external_id: "sold", name: "Phone sold")
    create(:product_crawl_result, product_crawl_setting:, external_id: "unmatched", name: "Case")
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.pluck(:external_id)).to contain_exactly("a", "excluded", kept.external_id)
  end

  it "既存の出品を重複させずに更新すること" do
    create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", price: 50)
    described_class.call(product_crawl_setting:)
    expect(product_crawl_setting.product_crawl_results.where(external_id: "a").sole).to have_attributes(
      name: "Phone blue", price: 100
    )
  end

  it "出品中と表示されても売却済みの出品と購入日を保持すること" do
    bought_date = 2.days.ago.beginning_of_day
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: true,
                                            bought_date:)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a", sold: false }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload).to have_attributes(sold: true, bought_date:)
  end

  it "既存の出品に売却済みの印を記録すること" do
    listing = create(:product_crawl_result, product_crawl_setting:, external_id: "a", name: "Phone old", sold: false)
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([
      { external_id: "a", name: "Phone blue", price: 100, product_url: "https://iosys.co.jp/items/a", sold: true }
    ])
    described_class.call(product_crawl_setting:)
    expect(listing.reload.sold).to be true
  end

  it "既存行を保持し価格なしの出品を除外して 0 円を受け入れること" do
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

  describe "詳細取得ジョブの投入" do
    let(:setting) { create(:product_crawl_setting) }
    let(:sources) { [{ status: "succeeded" }] }
    let(:results) { [{ platform: "mercari", external_id: "visible", reasons: [], price: 100, name: "Phone", product_url: "https://jp.mercari.com/item/visible", sold: false }] }

    before do
      allow(ProductMonitoring::Crawler).to receive(:call).and_return(sources: sources, results: results)
      allow(ProductMonitoring::CrawlDetailJob).to receive(:perform_async)
    end

    it "見つからない Yahoo の出品と新たに売却された出品をプラットフォームとともに投入すること" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "yahoo_fleamarket",
                                    external_id: "missing-yahoo", sold: false, updated_at: 4.hours.ago)
      results << { platform: "yahoo_fleamarket", external_id: "sold-yahoo", reasons: [], price: 100, name: "Phone",
                   product_url: "https://paypayfleamarket.yahoo.co.jp/item/sold-yahoo", sold: true }
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("missing-yahoo", "yahoo_fleamarket")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("sold-yahoo", "yahoo_fleamarket")
    end

    it "見つからない出品と売却日時のない出品を投入し表示中や iosys の出品は投入しないこと" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false,
                                    updated_at: 4.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "undated", sold: true,
                                    updated_at: 4.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "iosys", external_id: "iosys", sold: false)
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("missing")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("undated")
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async).with("visible")
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async).with("iosys")
    end

    it "見つからない出品中の商品を 3 時間待って再確認すること" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "recent", sold: false,
                                    updated_at: 2.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "old", sold: false,
                                    updated_at: 4.hours.ago)
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async).with("recent")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("old")
    end

    it "売却日時のない出品を 3 時間待って再確認すること" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "recent", sold: true,
                                    updated_at: 2.hours.ago)
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "old", sold: true,
                                    updated_at: 4.hours.ago)
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async).with("recent")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("old")
    end

    it "新規発見と新規売却の出品を直ちに確認すること" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "changed", sold: false)
      %w[new changed].each do |id|
        results << { platform: "mercari", external_id: id, reasons: [], price: 100, name: "Phone",
                     product_url: "https://jp.mercari.com/item/#{id}", sold: true }
      end
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("new")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("changed")
    end

    it "取得元のいずれかが失敗した場合は見つからない出品を投入しないこと" do
      create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "missing", sold: false,
                                    updated_at: 4.hours.ago)
      sources << { status: "failed" }
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async)
    end

    it "詳細取得ジョブを古い順に制限すること" do
      stub_const("ProductMonitoring::DetailCandidates::MAX_DETAIL_JOBS", 2)
      allow(Rails.logger).to receive(:info).and_call_original
      3.times do |n|
        create(:product_crawl_result, product_crawl_setting: setting, platform: "mercari", external_id: "m#{n}", sold: false,
                                      updated_at: (3 - n).days.ago)
      end
      described_class.call(product_crawl_setting: setting)
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("m0")
      expect(ProductMonitoring::CrawlDetailJob).to have_received(:perform_async).with("m1")
      expect(ProductMonitoring::CrawlDetailJob).not_to have_received(:perform_async).with("m2")
      expect(Rails.logger).to have_received(:info).with("Product crawl detail candidates: setting_id=#{setting.id} candidates=3 enqueued=2")
    end
  end
end
