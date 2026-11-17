require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::ListPage::Crawler do
  let(:url) { "https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro" }
  let(:setting) { create(:product_monitoring_crawl_setting, search_urls: [url]) }
  let(:page) { instance_double(Playwright::Page, url:) }
  let(:status) { 200 }
  let(:html) do
    <<~HTML
      <a href="/item/z123"><img src="https://example.com/image.jpg" alt="iPad"><p>12,000円</p><img alt="sold"></a>
    HTML
  end
  let(:empty_html) do
    data = { props: { initialState: { searchState: { search: {
      searchParams: { query: "iPad Pro" }, result: { metadata: { retriedWithVectorSearch: true } }
    } } } } }
    %(<script id="__NEXT_DATA__" type="application/json">#{data.to_json}</script>#{html})
  end

  before do
    allow(page).to receive(:goto) { instance_double(Playwright::Response, status:) }
    allow(page).to receive(:content).and_return(html)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).and_yield(page)
    allow(Kernel).to receive(:sleep)
    allow(Rails.logger).to receive(:warn)
  end

  it "出品を読み取り、次ページへ進むこと" do
    allow(page).to receive(:content).and_return(
      %(#{html}<a href="/search/iPad%20Pro?page=2"><img alt="次へボタンアイコン"></a>), html.sub("z123", "z456")
    )
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings]).to contain_exactly(
      { platform: "yahoo_fleamarket", external_id: "z123", name: "iPad", price: 12_000, sold: true,
        product_url: "https://paypayfleamarket.yahoo.co.jp/item/z123", thumbnail_url: "https://example.com/image.jpg" },
      include(external_id: "z456")
    )
    expect(page).to have_received(:goto).with("https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro?page=2")
  end

  it "最大5ページで打ち切ったときは、一覧を最後まで取得できなかったとすること" do
    allow(page).to receive(:content)
      .and_return(%(#{html}<a href="/search/iPad%20Pro?page=2"><img alt="次へボタンアイコン"></a>))
    result = described_class.call(crawl_setting: setting)
    expect(result[:complete]).to be false
    expect(page).to have_received(:goto).exactly(5).times
  end

  it "画像や価格のないリンクを除いてから1ページの上限に絞り、上限を超えたら一覧を最後まで取得できなかったとすること" do
    max = described_class::MAX_RESULTS_PER_PAGE
    invalid = '<a href="/item/noimage"><p>1,000円</p></a>' * 5
    valid = Array.new(max) { |n| %(<a href="/item/v#{n}"><img src="https://example.com/#{n}.jpg" alt="iPad"><p>1,000円</p></a>) }
    allow(page).to receive(:content).and_return("#{invalid}#{valid.join}")
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings].size).to eq(max)
    expect(result[:listings].pluck(:external_id)).not_to include("noimage")
    expect(result[:complete]).to be true

    over = %(<a href="/item/over"><img src="https://example.com/over.jpg" alt="iPad"><p>1,000円</p></a>)
    allow(page).to receive(:content).and_return("#{valid.join}#{over}")
    expect(described_class.call(crawl_setting: setting)).to include(complete: false)
  end

  it "別ホストの次ページは、検索ワードを伏せたURLで失敗として記録すること" do
    allow(page).to receive(:content)
      .and_return(%(#{html}<a href="https://evil.example/search/iPad%20Pro"><img alt="次へボタンアイコン"></a>))
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn).with(
      "Crawl failed for https://paypayfleamarket.yahoo.co.jp/search/[FILTERED]: RuntimeError: Unexpected next page URL"
    )
  end

  it "別ホストへの遷移と過大な HTML を失敗にすること" do
    allow(page).to receive(:url).and_return("https://evil.example/")
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    allow(page).to receive_messages(url:, content: "x" * ((10 * 1024 * 1024) + 1))
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
  end

  context "検索結果が 404 のとき" do
    let(:status) { 404 }

    it "空と確認できればおすすめの出品を保存せずに成功とすること" do
      allow(page).to receive(:content).and_return(empty_html)
      expect(described_class.call(crawl_setting: setting)).to eq(listings: [], complete: true)
    end

    it "検索ワードが違う、または通常の 404 なら失敗にすること" do
      setting.update!(search_urls: ["https://paypayfleamarket.yahoo.co.jp/search/other"])
      allow(page).to receive_messages(url: setting.search_urls.first, content: empty_html)
      expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
      allow(page).to receive(:content).and_return(empty_html.sub('"retriedWithVectorSearch":true',
                                                                 '"retriedWithVectorSearch":false'))
      expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    end
  end
end
