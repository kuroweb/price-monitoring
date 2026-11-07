require "rails_helper"

RSpec.describe ProductMonitoring::Sites::YahooAuction do
  let(:list) { Crawl::YahooAuction::SyncProducts::ListPage }
  let(:item) { instance_double(Playwright::ElementHandle) }

  before do
    allow(list).to receive_messages(not_crawlable?: false, external_id: "a123", name: "iPad",
                                    thumbnail_url: "https://example.com/image.jpg",
                                    auction_end_datetime: Time.zone.parse("2026-11-07 12:00"))
  end

  it "reads active prices and closed sale dates from the shared parser" do
    allow(list).to receive(:published_prices).with(item).and_return([1200, 2000])
    allow(list).to receive(:closed_price).with(item).and_return(1500)
    active = described_class.listing(item, closed: false)
    closed = described_class.listing(item, closed: true)
    expect(active).to include(external_id: "a123", price: 1200, buyout_price: 2000, sold: false, bought_date: nil)
    expect(closed).to include(price: 1500, sold: true, bought_date: closed[:end_date])
    expect(closed[:product_url]).to eq("https://auctions.yahoo.co.jp/jp/auction/a123")
  end

  it "preserves search filters while forcing the existing crawler's auction-only pagination" do
    uri = described_class.search_uri(URI("https://auctions.yahoo.co.jp/search/search?p=ipad&n=50&abatch=3"))
    expect(URI.decode_www_form(uri.query).to_h).to include("p" => "ipad", "n" => "100", "abatch" => "1,2",
                                                           "mode" => "2")
    page = instance_double(Playwright::Page)
    allow(list).to receive(:not_exist_next_page?).with(page).and_return(false)
    expect(URI.decode_www_form(described_class.next_url(uri, page).query).to_h).to include("b" => "101", "p" => "ipad")
  end

  it "rejects an unexpected final host and oversized responses" do
    page = instance_double(Playwright::Page, url: "https://example.com/", content: "")
    expect { described_class.validate_page(page) }.to raise_error(/Unexpected page URL/)
    allow(page).to receive_messages(url: "https://auctions.yahoo.co.jp/search/search",
                                    content: "x" * (10.megabytes + 1))
    expect { described_class.validate_page(page) }.to raise_error(/size limit/)
  end
end
