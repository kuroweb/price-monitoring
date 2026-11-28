require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Janpara::ListPage::Crawler do
  let(:url) { "https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro" }
  let(:setting) { create(:product_monitoring_crawl_setting, search_urls: [url]) }

  let(:visited) { [] }

  def stub_pages(*htmls)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute) do |**, &block|
      block.call(browser_page(htmls.size > 1 ? htmls.shift : htmls.first))
    end
  end

  def browser_page(html)
    page = instance_double(Playwright::Page, content: html)
    allow(page).to receive(:goto) do |url, **options|
      visited << [url, options]
      allow(page).to receive(:url).and_return(url)
      instance_double(Playwright::Response, status: 200)
    end
    page
  end

  it "商品グループと下限価格を読み取り、2つ目の金額を優先して次ページへ進むこと" do
    stub_pages(<<~HTML, '<div class="sorry"></div>')
      <div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?ITMCODE=123&amp;KEYWORDS=x">
      <img src="/image.jpg"><div class="search_itemname">iPad Pro</div>
      <div class="item_amount">¥20,000～</div><div class="item_amount">¥10,980～</div></a></div>
      <a class="pageLink" title="次ページ"></a>
    HTML
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings]).to contain_exactly(
      include(platform: "janpara", external_id: "ITMCODE=123", name: "iPad Pro", price: 10_980, sold: false,
              product_url: "https://www.janpara.co.jp/sale/search/detail/?ITMCODE=123",
              thumbnail_url: "https://www.janpara.co.jp/image.jpg")
    )
    expect(visited).to eq(
      [
        [url, { referer: "https://www.janpara.co.jp/" }],
        ["https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro&PAGE=2",
         { referer: "https://www.janpara.co.jp/" }]
      ]
    )
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute)
      .with(block_scripts: true, user_agent: described_class::USER_AGENT).twice
  end

  it "1ページの上限を超えた分は取得せず、一覧を最後まで取得できなかったとすること" do
    max = described_class::MAX_RESULTS_PER_PAGE
    item = '<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?ITMCODE=%d">' \
           '<div class="search_itemname">Phone</div><div class="item_amount">¥1,000</div></a></div>'
    stub_pages(Array.new(max + 1) { |n| format(item, n) }.join)
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings].size).to eq(max)
    expect(result[:complete]).to be false
  end

  it "価格のない SOLD OUT 表示を売り切れとして読み取ること" do
    stub_pages('<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?ITMCODE=313448">' \
               '<div class="search_itemname">Mac Studio</div><div class="search_nostock">SOLD OUT</div></a></div>')
    expect(described_class.call(crawl_setting: setting)[:listings])
      .to contain_exactly(include(external_id: "ITMCODE=313448", price: nil, sold: true))
  end

  it "1つの金額に2つの価格がある出品は価格なしにすること" do
    stub_pages('<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?SRCODE=1"></a>' \
               '<div class="search_itemname">Phone</div><div class="item_amount">¥1,000～¥2,000</div></div>')
    expect(described_class.call(crawl_setting: setting)[:listings].first[:price]).to be_nil
  end

  it "空結果は成功とし、出品も空結果もないページは失敗にすること" do
    stub_pages('<div class="sorry"></div>')
    expect(described_class.call(crawl_setting: setting)).to eq(listings: [], complete: true)
    stub_pages("<html></html>")
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
  end

  it "非 2xx の応答では Referer を付けて接続し直し、上限回数で失敗にすること" do
    allow(Kernel).to receive(:sleep)
    page = instance_double(Playwright::Page)
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 403))
    allow(ProductMonitoring::Crawling::Client).to receive(:execute) { |**, &block| block.call(page) }

    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute)
      .with(block_scripts: true, user_agent: described_class::USER_AGENT).exactly(described_class::FETCH_TRIES).times
    expect(page).to have_received(:goto)
      .with(url, referer: "https://www.janpara.co.jp/").exactly(described_class::FETCH_TRIES).times
  end
end
