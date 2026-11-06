require "rails_helper"

RSpec.describe Crawl::Search::Crawler do
  it "deduplicates by external_id and applies common inclusive filters" do
    allow(described_class).to receive(:fetch).and_return([
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "one" },
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "two" }
                                                         ])
    result = described_class.call(params: {
                                    search_urls: ["https://jp.mercari.com/search?q=x",
                                                  "https://jp.mercari.com/search?q=y"], min_price: "100", max_price: "100", required_keywords: ["phone"]
                                  })
    expect(result[:fetched_count]).to eq(1)
    expect(result[:accepted_count]).to eq(1)
  end

  it "rejects malformed ranges" do
    expect { described_class.call(params: { min_price: "x", search_urls: [] }) }.to raise_error(ArgumentError, /価格/)
  end

  it "keeps source failures independent and reports unsupported URLs" do
    allow(described_class).to receive(:fetch) do |target|
      raise Timeout::Error if target[:platform] == "mercari"

      []
    end
    result = described_class.call(params: { search_urls: [
                                    "https://jp.mercari.com/search?q=bad",
                                    "https://example.com/search?q=x",
                                    "https://iosys.co.jp/items?q=ok"
                                  ] })
    expect(result[:sources].map { |source| source[:status] }).to eq(%w[failed unsupported succeeded])
  end

  it "logs the failure without the URL query and keeps the public error unchanged" do
    allow(described_class).to receive(:fetch).and_raise(Timeout::Error, "timed out")
    allow(Rails.logger).to receive(:warn)
    result = described_class.call(params: { search_urls: ["https://jp.mercari.com/search?q=secret"] })
    expect(Rails.logger).to have_received(:warn).with("Crawl failed for https://jp.mercari.com/search: Timeout::Error: timed out")
    expect(result[:sources].first[:error]).to eq("Crawl failed")
  end

  it "uses AND required words, OR excluded words, and listing exclusion" do
    allow(described_class).to receive(:fetch).and_return([
                                                           { external_id: "same", name: "Phone blue", price: 50,
                                                             product_url: "item" },
                                                           { external_id: "other", name: "Phone red", price: 50,
                                                             product_url: "item" },
                                                           { external_id: "excluded", name: "Phone blue", price: 50,
                                                             product_url: "item" }
                                                         ])
    result = described_class.call(params: {
                                    search_urls: ["https://jp.mercari.com/search?q=x"],
                                    required_keywords: %w[phone blue], exclude_keywords: ["red"],
                                    exclude_external_ids: ["excluded"]
                                  })
    expect(result[:results].map { |row| row[:accepted] }).to eq([true, false, false])
    expect(result[:results].second[:reasons]).to include("missing_required_keyword", "excluded_keyword")
    expect(result[:results].last[:reasons]).to eq(["excluded_listing"])
  end

  it "does not treat malformed keyword parameters as empty filters" do
    expect do
      described_class.call(params: { required_keywords: "phone", search_urls: [] })
    end.to raise_error(ArgumentError)
  end

  it "extracts actual HTML and preserves the listing URL and query" do
    html = '<li data-testid="item-cell"><a href="/item/item-1"></a><span data-testid="thumbnail-item-name">Phone</span><span data-testid="item-tile-price">¥1,200</span></li>'
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new(html))
    result = described_class.call(params: { search_urls: ["https://jp.mercari.com/search?q=phone&sort=price"] })
    expect(described_class).to have_received(:fetch_page).with(URI("https://jp.mercari.com/search?q=phone&sort=price"))
    expect(result[:results].first).to include(external_id: "item-1", price: 1200,
                                              thumbnail_url: "https://static.mercdn.net/thumb/item/webp/item-1_1.jpg", product_url: "https://jp.mercari.com/item/item-1")
  end

  it "reads the lazy-loaded iosys thumbnail" do
    html = %(<li class="item"><a href="/items/phone/1"></a><img src="/dummy.gif" data-src="https://cdn.example/1_S.jpg"><span class="name">Phone</span><span class="price">1,000円</span></li>)
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new(html))
    result = described_class.call(params: { search_urls: ["https://iosys.co.jp/items?q=phone"] })
    expect(result[:results].first).to include(external_id: "phone/1", thumbnail_url: "https://cdn.example/1_S.jpg")
  end

  it "recognizes explicit empty results and rejects an unknown page" do
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new('<div id="empty">該当する商品がありません</div>'))
    result = described_class.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })
    expect(result[:sources].first[:status]).to eq("succeeded")
    expect(result[:fetched_count]).to eq(0)
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new("<html>challenge</html>"))
    expect(described_class.call(params: { search_urls: ["https://iosys.co.jp/items?q=none"] })[:sources].first[:status]).to eq("failed")
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
    expect { described_class.fetch_page(URI("https://iosys.co.jp/items?q=x")) }.to raise_error(/size limit/)
  end
end
