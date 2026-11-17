require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooAuction::ListPage::Crawler do
  let(:setting) do
    create(:product_monitoring_crawl_setting, search_keyword: "ipad", platforms: ["yahoo_auction"], search_urls: [])
  end
  let(:page) { instance_double(Playwright::Page, url: "https://auctions.yahoo.co.jp/search/search") }
  let(:listing_html) do
    <<~HTML
      <li><div><a href="https://auctions.yahoo.co.jp/jp/auction/a123" class="wb_break-all">iPad</a>
      <a href="/seller/seller1">seller</a><div class="lg:grid-tc_1fr_160px">現在1,200円</div></div></li>
    HTML
  end

  before do
    allow(page).to receive_messages(goto: instance_double(Playwright::Response, status: 200), wait_for_function: nil)
    allow(page).to receive(:content).and_return(listing_html)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).with(allow_images: true).and_yield(page)
  end

  it "出品中と落札相場の両方を、一覧表示・100件単位で取得すること" do
    expect(described_class.call(crawl_setting: setting)).to contain_exactly(include(external_id: "a123",
                                                                                    price: 1200))
    expect(page).to have_received(:goto)
      .with("https://auctions.yahoo.co.jp/search/search?p=ipad&mode=2&n=100&abatch=1%2C2")
    expect(page).to have_received(:goto)
      .with("https://auctions.yahoo.co.jp/closedsearch/closedsearch?p=ipad&mode=2&n=100&abatch=1%2C2")
  end

  it "検索結果URLの絞り込みを保ちながら、ページ送りの指定を既存クローラーと同じにすること" do
    setting.update!(search_keyword: nil, platforms: [], search_urls: ["https://auctions.yahoo.co.jp/search/search?p=ipad&n=50&abatch=3"])
    described_class.call(crawl_setting: setting)
    expect(page).to have_received(:goto).with("https://auctions.yahoo.co.jp/search/search?p=ipad&mode=2&n=100&abatch=1%2C2")
  end

  it "一覧の描画を待ってから、別ホストへの遷移を失敗として記録すること" do
    allow(page).to receive(:url).and_return("https://auctions.yahoo.co.jp/search/search", "https://example.com/")
    allow(Rails.logger).to receive(:warn)
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(page).to have_received(:wait_for_function).with(described_class::LIST_READY).at_least(:once)
    expect(Rails.logger).to have_received(:warn).with(/Unexpected page URL/).at_least(:once)
  end

  it "過大な応答を失敗として記録すること" do
    allow(page).to receive(:content).and_return("x" * (10.megabytes + 1))
    allow(Rails.logger).to receive(:warn)
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn).with(/size limit/).at_least(:once)
  end
end
