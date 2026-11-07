require "rails_helper"

RSpec.describe ProductMonitoring::Sites::Iosys do
  it "reads the lazy-loaded iosys thumbnail" do
    html = <<~HTML
      <li class="item"><a href="/items/phone/1"></a><img src="/dummy.gif" data-src="https://cdn.example/1_S.jpg">
      <span class="name">Phone</span><span class="price">1,000円</span></li>
    HTML
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new(html))
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=phone"] })
    expect(result[:results].first).to include(external_id: "phone/1", thumbnail_url: "https://cdn.example/1_S.jpg")
  end

  it "does not turn a price range into a single price and resolves relative iosys images" do
    html = <<~HTML
      <li class="item"><a href="/items/phone/1"></a><img src="/photos/no_photo_S.jpg">
      <span class="name">Phone</span><div class="price"><span>65,800円</span>～<span>117,800円</span><p>(税込)</p></div></li>
    HTML
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new(html))
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=phone"] })
    expect(result[:results].first).to include(price: nil, thumbnail_url: "https://iosys.co.jp/photos/no_photo_S.jpg")
    expect(ProductMonitoring::Crawler.parse_price("20,800円 (税込)")).to eq(20_800)
    expect(ProductMonitoring::Crawler.parse_price("¥1,200")).to eq(1200)
    expect(ProductMonitoring::Crawler.parse_price("2,147,483,648円")).to be_nil
  end

  it "recognizes explicit empty results and rejects an unknown page" do
    allow(described_class).to receive(:fetch_page)
      .and_return(Struct.new(:body).new('<div id="empty">該当する商品がありません</div>'))
    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })
    expect(result[:sources].first[:status]).to eq("succeeded")
    expect(result[:fetched_count]).to eq(0)
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new("<html>challenge</html>"))
    failed = ProductMonitoring::Crawler.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })
    expect(failed[:sources].first[:status]).to eq("failed")
  end

  it "connects with TLS verification and limits streamed response size" do
    http = instance_double(Net::HTTP)
    allow(Net::HTTP).to receive(:new).with("iosys.co.jp", 443, nil).and_return(http)
    %i[use_ssl= verify_mode= open_timeout= read_timeout= write_timeout=].each do |method|
      allow(http).to receive(method)
    end
    allow(http).to receive(:start).and_yield(http)
    response = Net::HTTPOK.new("1.1", "200", "OK")
    allow(response).to receive(:read_body) { |&block| block ? block.call("ok") : "ok" }
    allow(http).to receive(:request).and_yield(response).and_return(response)
    expect(described_class.fetch_page(URI("https://iosys.co.jp/items?q=x")).body).to eq("ok")
    allow(response).to receive(:read_body).and_yield("x" * (described_class::MAX_RESPONSE_BYTES + 1))
    expect do
      described_class.fetch_page(URI("https://iosys.co.jp/items?q=x"))
    end.to raise_error(/size limit/)
  end

  it "follows only an available next page and preserves other query parameters" do
    uri = URI("https://iosys.co.jp/items?q=ipad+mini&page=2")
    expect(described_class.next_url(uri, Nokogiri::HTML("<html></html>"))).to be_nil
    next_uri = described_class.next_url(uri, Nokogiri::HTML('<a class="page-link" rel="next"></a>'))
    expect(URI.decode_www_form(next_uri.query).to_h).to include("page" => "3")
    expect(URI.decode_www_form(next_uri.query).to_h).to include("q" => "ipad mini")
  end

  it "stops after the maximum number of pages" do
    uri = URI("https://iosys.co.jp/items?q=ipad+mini&page=2")
    allow(described_class).to receive(:fetch).and_return([[{ external_id: "one" }], uri])
    result = ProductMonitoring::Crawler.fetch(site: described_class, canonical_url: uri.to_s)
    expect(described_class).to have_received(:fetch).exactly(ProductMonitoring::Crawler::MAX_PAGES_PER_URL).times
    expect(result.size).to eq(ProductMonitoring::Crawler::MAX_PAGES_PER_URL)
  end
end
