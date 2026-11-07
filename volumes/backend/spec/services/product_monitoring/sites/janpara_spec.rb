require "rails_helper"

RSpec.describe ProductMonitoring::Sites::Janpara do
  let(:uri) { URI("https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro") }

  it "extracts a product group and its lower price, preferring the second amount" do
    html = <<~HTML
      <div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?ITMCODE=123&amp;KEYWORDS=x">
      <img src="/image.jpg"><div class="search_itemname">iPad Pro</div>
      <div class="item_amount">¥20,000～</div><div class="item_amount">¥10,980～</div></a></div>
      <a class="pageLink" title="次ページ"></a>
    HTML
    allow(described_class).to receive(:fetch_page).and_return(html)
    results, next_uri = described_class.fetch(uri)
    expect(results.first).to include(external_id: "ITMCODE=123", name: "iPad Pro", price: 10_980, sold: false,
                                     product_url: "https://www.janpara.co.jp/sale/search/detail/?ITMCODE=123",
                                     thumbnail_url: "https://www.janpara.co.jp/image.jpg")
    expect(URI.decode_www_form(next_uri.query).to_h).to include("KEYWORDS" => "iPad Pro", "PAGE" => "2")
  end

  it "rejects ranges with two prices and recognizes empty results" do
    html = '<div class="search_item_s"><a class="search_itemlink" href="/sale/search/detail/?SRCODE=1"></a>' \
           '<div class="search_itemname">Phone</div><div class="item_amount">¥1,000～¥2,000</div></div>'
    allow(described_class).to receive(:fetch_page).and_return(html, '<div class="sorry"></div>', "<html></html>")
    expect(described_class.fetch(uri).first.first[:price]).to be_nil
    expect(described_class.fetch(uri).first).to be_empty
    expect { described_class.fetch(uri) }.to raise_error(/no extractable listings/)
  end

  it "checks the browser response, final host, and HTML size" do
    page = instance_double(Playwright::Page, url: uri.to_s, content: "ok")
    response = instance_double(Playwright::Response, status: 200)
    allow(page).to receive_messages(goto: response)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    expect(described_class.fetch_page(uri)).to eq("ok")
    allow(page).to receive_messages(url: "https://evil.example/")
    expect { described_class.fetch_page(uri) }.to raise_error(/Unexpected page URL/)
    allow(page).to receive_messages(url: uri.to_s, content: "x" * (described_class::MAX_RESPONSE_BYTES + 1))
    expect { described_class.fetch_page(uri) }.to raise_error(/size limit/)
  end
end
