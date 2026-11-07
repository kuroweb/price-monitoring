require "rails_helper"

RSpec.describe ProductMonitoring::Sites::YahooAuction do
  include ActiveSupport::Testing::TimeHelpers

  def item(price)
    Nokogiri::HTML.fragment(<<~HTML).at_css("li")
      <li><div><a href="https://auctions.yahoo.co.jp/jp/auction/a123" class="wb_break-all">iPad</a>
        <a href="/seller/seller1">seller</a><img src="https://example.com/image.jpg">
        <div class="lg:grid-tc_1fr_160px">#{price}</div><span>11/07 12:00終了</span>
      </div></li>
    HTML
  end

  it "waits for the rendered search results and extracts listings" do
    uri = URI("https://auctions.yahoo.co.jp/search/search?p=ipad")
    html = <<~HTML
      <li><div><a href="https://auctions.yahoo.co.jp/jp/auction/a123" class="wb_break-all">iPad</a>
      <a href="/seller/seller1">seller</a><div class="lg:grid-tc_1fr_160px">現在1,200円</div></div></li>
    HTML
    page = instance_double(Playwright::Page, url: uri.to_s)
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(page).to receive(:content).and_return("<html></html>", html)
    allow(page).to receive(:wait_for_function)
    allow(Crawl::Client).to receive(:execute).with(allow_images: true).and_yield(page)

    results, next_uri = described_class.fetch(uri)

    expect(page).to have_received(:goto).with(described_class.search_uri(uri).to_s)
    expect(page).to have_received(:wait_for_function).with(described_class::LIST_READY)
    expect(results).to contain_exactly(include(external_id: "a123", price: 1200))
    expect(next_uri).to be_nil
  end

  it "rejects a redirect to another host after waiting for results" do
    uri = URI("https://auctions.yahoo.co.jp/search/search?p=ipad")
    page = instance_double(Playwright::Page, content: "<html></html>")
    allow(page).to receive(:url).and_return(uri.to_s, "https://example.com/")
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(page).to receive(:wait_for_function)
    allow(Crawl::Client).to receive(:execute).with(allow_images: true).and_yield(page)

    expect { described_class.fetch(uri) }.to raise_error(/Unexpected page URL/)
    expect(page).to have_received(:wait_for_function).with(described_class::LIST_READY)
  end

  it "reads active prices and closed sale dates" do
    travel_to Time.zone.parse("2026-11-07 10:00") do
      active = described_class.listing(item("現在1,200円 即決2,000円"), closed: false)
      closed = described_class.listing(item("落札1,500円"), closed: true)
      expect(active).to include(external_id: "a123", name: "iPad", price: 1200, buyout_price: 2000,
                                thumbnail_url: "https://example.com/image.jpg", sold: false, bought_date: nil,
                                end_date: Time.zone.parse("2026-11-07 12:00"))
      expect(closed).to include(price: 1500, sold: true, bought_date: closed[:end_date])
      expect(closed[:product_url]).to eq("https://auctions.yahoo.co.jp/jp/auction/a123")
    end
  end

  it "treats a buyout-only price as the current price" do
    expect(described_class.listing(item("即決2,000円"), closed: false)).to include(price: 2000, buyout_price: nil)
  end

  it "uses the remaining time when an end date is unavailable" do
    travel_to Time.zone.parse("2026-11-07 10:00") do
      node = item("現在1,200円")
      node.at_css("span").content = "1時間2分3秒"
      expect(described_class.listing(node, closed: false)[:end_date]).to eq(3723.seconds.from_now)
    end
  end

  it "returns no results for an empty search and rejects unrecognised pages" do
    uri = URI("https://auctions.yahoo.co.jp/search/search?p=ipad")
    expect(described_class.page_results(uri, Nokogiri::HTML('<div class="Notice__wandQuery"></div>'))).to eq([[], nil])
    expect { described_class.page_results(uri, Nokogiri::HTML("<div>unexpected</div>")) }
      .to raise_error("Search page has no extractable listings")
  end

  it "preserves search filters while forcing the existing crawler's auction-only pagination" do
    uri = described_class.search_uri(URI("https://auctions.yahoo.co.jp/search/search?p=ipad&n=50&abatch=3"))
    expect(URI.decode_www_form(uri.query).to_h).to include("p" => "ipad", "n" => "100", "abatch" => "1,2",
                                                           "mode" => "2")
    page = Nokogiri::HTML('<a href="?b=101">次へ</a>')
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
