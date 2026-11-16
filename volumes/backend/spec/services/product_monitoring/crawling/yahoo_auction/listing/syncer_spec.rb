require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooAuction::Listing::Syncer do
  let(:product_crawl_setting) do
    create(:product_crawl_setting, required_keywords: ["phone"],
                                   search_urls: ["https://auctions.yahoo.co.jp/search/search?p=phone"])
  end
  let(:listings) { [] }

  before do
    allow(ProductMonitoring::Crawling::YahooAuction::Listing::Crawler).to receive(:call) do
      listings.map { |listing| listing.merge(platform: "yahoo_auction", name: "Phone blue", price: 100) }
    end
  end

  def listing(id, **attributes)
    create(:product_crawl_result, product_crawl_setting:, platform: "yahoo_auction", external_id: id, name: "Phone old",
                                  **attributes)
  end

  it "既存の売却情報を保ってオークションの価格と日時を保存すること" do
    bought_date = 2.days.ago.change(usec: 0)
    end_date = 1.day.from_now.change(usec: 0)
    saved = listing("a", sold: true, bought_date:)
    listings << { external_id: "a", buyout_price: 200, end_date:, product_url: "https://auctions.yahoo.co.jp/jp/auction/a",
                  sold: false }
    described_class.call(product_crawl_setting:)
    expect(saved.reload).to have_attributes(sold: true, bought_date:, buyout_price: 200, end_date:)
  end

  it "終了したオークションの出品から売れた日を記録すること" do
    bought_date = 2.days.ago.change(usec: 0)
    saved = listing("a", sold: false, buyout_price: 200)
    listings << { external_id: "a", end_date: bought_date, bought_date:, product_url: "https://auctions.yahoo.co.jp/jp/auction/a",
                  sold: true }
    described_class.call(product_crawl_setting:)
    expect(saved.reload).to have_attributes(sold: true, bought_date:, end_date: bought_date, buyout_price: 200)
  end

  it "オークションの価格と売れた日をまとめて更新すること" do
    dates = Array.new(4) { |n| (2.days.ago + n.minutes).change(usec: 0) }
    saved = %w[a b c].map { |id| listing(id, sold: false) }
    saved.first.update!(bought_date: 3.days.ago.change(usec: 0), buyout_price: 300)
    original_date = saved.first.bought_date
    %w[a b c d].each_with_index do |id, index|
      listings << { external_id: id, buyout_price: (index.zero? ? nil : 200), bought_date: dates[index],
                    end_date: dates[index], product_url: "https://auctions.yahoo.co.jp/jp/auction/#{id}", sold: true }
    end
    statements = []
    subscriber = lambda do |_name, _start, _finish, _id, payload|
      statements << payload[:sql] if payload[:sql].match?(/\A(?:UPDATE|INSERT INTO) .*product_crawl_results/i)
    end
    ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
      described_class.call(product_crawl_setting:)
    end
    expect(saved.first.reload).to have_attributes(buyout_price: 300, bought_date: original_date)
    expect(saved[1].reload).to have_attributes(buyout_price: 200, bought_date: dates[1])
    expect(product_crawl_setting.product_crawl_results.find_by!(external_id: "d"))
      .to have_attributes(buyout_price: 200, bought_date: dates[3])
    expect(statements.count { |sql| sql.match?(/\AINSERT/i) }).to eq(1)
    expect(statements.count { |sql| sql.match?(/\AUPDATE/i) }).to eq(1)
  end

  it "既存の出品に売り切れを記録すること" do
    saved = listing("a", sold: false)
    listings << { external_id: "a", product_url: "https://auctions.yahoo.co.jp/jp/auction/a", sold: true }
    described_class.call(product_crawl_setting:)
    expect(saved.reload.sold).to be true
  end
end
