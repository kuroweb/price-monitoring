require "rails_helper"

RSpec.describe ProductMonitoring::Sites::Iosys do
  it "遅延読み込みされた iosys のサムネイルを読み取ること" do
    html = <<~HTML
      <li class="item"><a href="/items/phone/1"></a><img src="/dummy.gif" data-src="https://cdn.example/1_S.jpg">
      <span class="name">Phone</span><span class="price">1,000円</span></li>
    HTML
    allow(described_class).to receive(:fetch_page).and_return(html)
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=phone"] })
    expect(result[:results].first).to include(external_id: "phone/1", sold: false, thumbnail_url: "https://cdn.example/1_S.jpg")
  end

  it "価格帯を単一価格にせず iosys の相対画像 URL を解決すること" do
    html = <<~HTML
      <li class="item"><a href="/items/phone/1"></a><img src="/photos/no_photo_S.jpg">
      <span class="name">Phone</span><div class="price"><span>65,800円</span>～<span>117,800円</span><p>(税込)</p></div></li>
    HTML
    allow(described_class).to receive(:fetch_page).and_return(html)
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=phone"] })
    expect(result[:results].first).to include(price: nil, thumbnail_url: "https://iosys.co.jp/photos/no_photo_S.jpg")
    expect(ProductMonitoring::Crawler.parse_price("20,800円 (税込)")).to eq(20_800)
    expect(ProductMonitoring::Crawler.parse_price("¥1,200")).to eq(1200)
    expect(ProductMonitoring::Crawler.parse_price("2,147,483,648円")).to be_nil
  end

  it "明示的な空結果を認識し不明なページを拒否すること" do
    allow(described_class).to receive(:fetch_page)
      .and_return('<div id="empty">該当する商品がありません</div>')
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })
    expect(result[:sources].first[:status]).to eq("succeeded")
    expect(result[:fetched_count]).to eq(0)
    allow(described_class).to receive(:fetch_page).and_return("<html>challenge</html>")
    failed = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })
    expect(failed[:sources].first[:status]).to eq("failed")
  end

  it "プロキシ経由のブラウザでイオシスのホストに限って取得すること" do
    uri = URI("https://iosys.co.jp/items?q=x")
    allow(ProductMonitoring::Sites::BrowserPage).to receive(:fetch).and_return("ok")
    expect(described_class.fetch_page(uri)).to eq("ok")
    expect(ProductMonitoring::Sites::BrowserPage).to have_received(:fetch)
      .with(uri, host: "iosys.co.jp", max_bytes: described_class::MAX_RESPONSE_BYTES)
  end

  it "利用可能な次ページのみをたどり他のクエリパラメータを保持すること" do
    uri = URI("https://iosys.co.jp/items?q=ipad+mini&page=2")
    expect(described_class.next_url(uri, Nokogiri::HTML("<html></html>"))).to be_nil
    next_uri = described_class.next_url(uri, Nokogiri::HTML('<a class="page-link" rel="next"></a>'))
    expect(URI.decode_www_form(next_uri.query).to_h).to include("page" => "3")
    expect(URI.decode_www_form(next_uri.query).to_h).to include("q" => "ipad mini")
  end

  it "最大ページ数に達すると停止すること" do
    uri = URI("https://iosys.co.jp/items?q=ipad+mini&page=2")
    allow(described_class).to receive(:fetch).and_return([[{ external_id: "one" }], uri])
    result = ProductMonitoring::Crawler.fetch(site: described_class, canonical_url: uri.to_s)
    expect(described_class).to have_received(:fetch).exactly(ProductMonitoring::Crawler::MAX_PAGES_PER_URL).times
    expect(result.size).to eq(ProductMonitoring::Crawler::MAX_PAGES_PER_URL)
  end
end
