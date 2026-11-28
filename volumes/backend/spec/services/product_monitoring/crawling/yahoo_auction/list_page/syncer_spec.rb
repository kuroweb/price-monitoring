require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooAuction::ListPage::Syncer do
  let(:crawl_setting) do
    create(:product_monitoring_crawl_setting, required_keywords: ["phone"],
                                              search_urls: ["https://auctions.yahoo.co.jp/search/search?p=phone"])
  end
  let(:listings) { [] }

  before do
    allow(ProductMonitoring::Crawling::YahooAuction::ListPage::Crawler).to receive(:call) do
      listings.map { |listing| listing.merge(platform: "yahoo_auction", name: "Phone blue", price: 100) }
    end
  end

  def listing(id, **attributes)
    create(:product_monitoring_crawl_result, crawl_setting:, platform: "yahoo_auction",
                                             external_id: id, name: "Phone old",
                                             **attributes)
  end

  it "既存の売却情報を保ってオークションの価格と日時を保存すること" do
    sold_at = 2.days.ago.change(usec: 0)
    ends_at = 1.day.from_now.change(usec: 0)
    saved = listing("a", sold: true, sold_at:)
    listings << {
      external_id: "a", buyout_price: 200, ends_at:, product_url: "https://auctions.yahoo.co.jp/jp/auction/a",
      sold: false
    }
    described_class.call(crawl_setting:)
    expect(saved.reload).to have_attributes(sold: true, sold_at:, buyout_price: 200, ends_at:)
  end

  it "終了したオークションの出品から売れた日を記録すること" do
    sold_at = 2.days.ago.change(usec: 0)
    saved = listing("a", sold: false, buyout_price: 200)
    listings << {
      external_id: "a", ends_at: sold_at, sold_at:, product_url: "https://auctions.yahoo.co.jp/jp/auction/a",
      sold: true
    }
    described_class.call(crawl_setting:)
    expect(saved.reload).to have_attributes(sold: true, sold_at:, ends_at: sold_at, buyout_price: 200,
                                            recency_at: sold_at)
  end

  it "オークションの価格と売れた日をまとめて更新すること" do
    dates = Array.new(4) { |n| (2.days.ago + n.minutes).change(usec: 0) }
    saved = %w[a b c].map { |id| listing(id, sold: false) }
    saved.first.update!(sold_at: 3.days.ago.change(usec: 0), buyout_price: 300)
    original_date = saved.first.sold_at
    %w[a b c d].each_with_index do |id, index|
      listings << { external_id: id, buyout_price: (index.zero? ? nil : 200), sold_at: dates[index],
                    ends_at: dates[index], product_url: "https://auctions.yahoo.co.jp/jp/auction/#{id}", sold: true }
    end
    statements = []
    subscriber = lambda do |_name, _start, _finish, _id, payload|
      statements << payload[:sql] if payload[:sql].match?(/\A(?:UPDATE|INSERT INTO) .*crawl_results/i)
    end
    ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.call(crawl_setting:)
    end
    expect(saved.first.reload).to have_attributes(buyout_price: 300, sold_at: original_date)
    expect(saved[1].reload).to have_attributes(buyout_price: 200, sold_at: dates[1])
    expect(crawl_setting.crawl_results.find_by!(external_id: "d"))
      .to have_attributes(buyout_price: 200, sold_at: dates[3])
    expect(statements.count { |sql| sql.match?(/\AINSERT/i) }).to eq(1)
    expect(statements.count { |sql| sql.match?(/\AUPDATE/i) }).to eq(1)
  end

  it "既存の出品に売り切れを記録すること" do
    saved = listing("a", sold: false)
    listings << { external_id: "a", product_url: "https://auctions.yahoo.co.jp/jp/auction/a", sold: true }
    described_class.call(crawl_setting:)
    expect(saved.reload.sold).to be true
  end

  it "一覧で分かった出品者IDを保存し、更新日時は進めず、一覧で分からないときは既知の出品者IDを空で上書きしないこと" do
    found = { external_id: "with-seller", sold: false,
              product_url: "https://auctions.yahoo.co.jp/jp/auction/with-seller" }
    listings << found.merge(seller_id: "Seller_1")
    described_class.call(crawl_setting: crawl_setting)
    saved = crawl_setting.crawl_results.find_by!(external_id: "with-seller")
    expect(saved.seller_id).to eq("Seller_1")

    checked_at = 4.hours.ago.change(usec: 0)
    saved.update_columns(seller_id: nil, updated_at: checked_at) # rubocop:disable Rails/SkipsModelValidations
    described_class.call(crawl_setting: crawl_setting)
    expect(saved.reload).to have_attributes(seller_id: "Seller_1", updated_at: checked_at)

    listings[-1] = found.merge(seller_id: nil)
    described_class.call(crawl_setting: crawl_setting)
    expect(saved.reload.seller_id).to eq("Seller_1")
  end
end
