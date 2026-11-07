require "rails_helper"

RSpec.describe ProductMonitoring::Sites::YahooFleamarket do
  let(:url) { URI("https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro") }
  let(:html) do
    <<~HTML
      <a href="/item/z123"><img src="https://example.com/image.jpg" alt="iPad"><p>12,000円</p><img alt="sold"></a>
      <a href="/search/iPad%20Pro?page=2"><img alt="次へボタンアイコン"></a>
    HTML
  end

  it "出品と次の検索ページを抽出する" do
    allow(described_class).to receive(:fetch_page).and_return(html)
    results, next_url = described_class.fetch(url)
    expect(results).to contain_exactly(include(external_id: "z123", name: "iPad", price: 12_000, sold: true,
                                               product_url: "https://paypayfleamarket.yahoo.co.jp/item/z123"))
    expect(next_url.to_s).to eq("https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro?page=2")
  end

  it "別ホストの次ページを拒否する" do
    page = Nokogiri::HTML('<a href="https://evil.example/search/iPad%20Pro"><img alt="次へボタンアイコン"></a>')
    expect { described_class.next_url(url, page) }.to raise_error("Unexpected next page URL")
  end

  it "リダイレクト先のページと過大な描画済み HTML を拒否する" do
    response = instance_double(Playwright::Response, status: 200)
    page = instance_double(Playwright::Page, url: "https://evil.example/", content: "ok")
    allow(page).to receive(:goto).and_return(response)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    expect { described_class.fetch_page(url) }.to raise_error("Unexpected page URL")

    allow(page).to receive_messages(url: "https://paypayfleamarket.yahoo.co.jp/search/ipad", content: "x" * 11)
    stub_const("ProductMonitoring::Sites::YahooFleamarket::MAX_RESPONSE_BYTES", 10)
    allow(described_class).to receive(:sleep)
    expect { described_class.fetch_page(url) }.to raise_error("Response exceeds size limit")
  end

  it "空と確認された 404 を成功として扱いおすすめ出品を保存しない" do
    data = { props: { initialState: { searchState: { search: {
      searchParams: { query: "iPad Pro" }, result: { metadata: { retriedWithVectorSearch: true } }
    } } } } }
    empty_html = %(<script id="__NEXT_DATA__" type="application/json">#{data.to_json}</script>) + html
    response = instance_double(Playwright::Response, status: 404)
    page = instance_double(Playwright::Page, url: url.to_s, content: empty_html)
    allow(page).to receive_messages(goto: response, content: empty_html, url: url.to_s)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    allow(described_class).to receive(:sleep)

    expect(described_class.fetch(url)).to eq([[], nil])
    other_url = URI("https://paypayfleamarket.yahoo.co.jp/search/other")
    expect(described_class.empty_search?(empty_html, other_url)).to be(false)
    ordinary_html = empty_html.sub('"retriedWithVectorSearch":true', '"retriedWithVectorSearch":false')
    expect(described_class.empty_search?(ordinary_html, url)).to be(false)
    expect { described_class.fetch_detail("z123") }.to raise_error("Non-success HTTP response")
    allow(page).to receive_messages(content: html)
    expect { described_class.fetch(url) }.to raise_error("Non-success HTTP response")
    allow(page).to receive_messages(content: empty_html, url: "https://evil.example/")
    expect { described_class.fetch(url) }.to raise_error("Unexpected page URL")
    allow(page).to receive_messages(url: url.to_s)
    stub_const("ProductMonitoring::Sites::YahooFleamarket::MAX_RESPONSE_BYTES", 10)
    expect { described_class.fetch(url) }.to raise_error("Response exceeds size limit")
  end

  it "販売者の文言ではなく商品の構造化データから在庫状態を判定する" do
    html = '<div>売り切れ</div><script type="application/ld+json">' \
           '{"@type":"Product","offers":{"availability":"https://schema.org/InStock"}}</script>'
    allow(described_class).to receive(:fetch_page).and_return(html)
    expect(described_class.fetch_detail("z123")).to eq(sold: false, bought_date: nil)
    expect(described_class.detail_sold(Nokogiri::HTML("<div>売り切れ</div>"))).to be_nil
  end

  it "売却済み出品の構造化された更新日時を読み取る" do
    html = '<script type="application/ld+json">' \
           '{"@type":"Product","offers":{"availability":"https://schema.org/OutOfStock"}}</script>' \
           '<aside><img alt="時計アイコン"><span>2日前に更新</span></aside>'
    allow(described_class).to receive(:fetch_page).and_return(html)
    expect(described_class.fetch_detail("z123")).to eq(sold: true, bought_date: 2.days.ago.beginning_of_day)
  end
end
