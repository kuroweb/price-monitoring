require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Janpara::Listing::Crawler do
  let(:url) { "https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro" }
  let(:setting) { create(:product_crawl_setting, search_urls: [url]) }

  let(:visited) { [] }

  # 渡した HTML を順に返し、最後の HTML は繰り返す
  def stub_pages(*htmls)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute) do |**, &block|
      block.call(browser_page(htmls.size > 1 ? htmls.shift : htmls.first))
    end
  end

  def browser_page(html)
    page = instance_double(Playwright::Page, content: html)
    allow(page).to receive(:goto) do |url|
      visited << url
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
    result = described_class.call(product_crawl_setting: setting)
    expect(result[:listings]).to contain_exactly(
      include(platform: "janpara", external_id: "ITMCODE=123", name: "iPad Pro", price: 10_980, sold: false,
              product_url: "https://www.janpara.co.jp/sale/search/detail/?ITMCODE=123",
              thumbnail_url: "https://www.janpara.co.jp/image.jpg")
    )
    expect(visited).to include("https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro&PAGE=2")
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute)
      .with(block_scripts: true, user_agent: described_class::USER_AGENT).twice
  end

  it "価格のない SOLD OUT 表示を売り切れとして読み取ること" do
    stub_pages('<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?ITMCODE=313448">' \
               '<div class="search_itemname">Mac Studio</div><div class="search_nostock">SOLD OUT</div></a></div>')
    expect(described_class.call(product_crawl_setting: setting)[:listings])
      .to contain_exactly(include(external_id: "ITMCODE=313448", price: nil, sold: true))
  end

  it "1つの金額に2つの価格がある出品は価格なしにすること" do
    stub_pages('<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?SRCODE=1"></a>' \
               '<div class="search_itemname">Phone</div><div class="item_amount">¥1,000～¥2,000</div></div>')
    expect(described_class.call(product_crawl_setting: setting)[:listings].first[:price]).to be_nil
  end

  it "空結果は成功とし、出品も空結果もないページは失敗にすること" do
    stub_pages('<div class="sorry"></div>')
    expect(described_class.call(product_crawl_setting: setting)).to eq(listings: [], complete: true)
    stub_pages("<html></html>")
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
  end
end
