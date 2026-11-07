require "rails_helper"

RSpec.describe ProductMonitoring::Sites::Mercari do
  it "extracts actual HTML and preserves the listing URL and query" do
    html = <<~HTML
      <li data-testid="item-cell"><a href="/item/item-1"></a><span data-testid="thumbnail-item-name">Phone</span>
      <span data-testid="item-tile-price">¥1,200</span><img alt="Phoneのサムネイル 売り切れ"></li>
    HTML
    allow(described_class).to receive(:fetch_mercari_page).and_return(html)
    url = "https://jp.mercari.com/search?q=phone&sort=price"
    result = ProductMonitoring::Crawler.call(params: { search_urls: [url] })
    expect(described_class).to have_received(:fetch_mercari_page).with(URI("https://jp.mercari.com/search?q=phone&sort=price"))
    expect(result[:results].first).to include(external_id: "item-1", price: 1200, sold: true,
                                              thumbnail_url: "https://static.mercdn.net/thumb/item/webp/item-1_1.jpg",
                                              product_url: "https://jp.mercari.com/item/item-1")
  end

  it "renders the Mercari search page with the existing browser client" do
    page = instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), content: "<html></html>",
                                             url: "https://jp.mercari.com/search?q=phone")
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(page.mouse).to receive(:wheel)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    allow(described_class).to receive(:sleep)

    expect(described_class.fetch_mercari_page(URI("https://jp.mercari.com/search?q=phone"))).to eq("<html></html>")
    expect(page).to have_received(:goto).with("https://jp.mercari.com/search?q=phone")
    expect(page.mouse).to have_received(:wheel).exactly(30).times
  end

  it "fails the URL and logs a sanitized warning when redirected to another host" do
    page = instance_double(Playwright::Page, url: "https://example.com/")
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    allow(Rails.logger).to receive(:warn)

    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://jp.mercari.com/search?keyword=private"] })
    expect(result[:sources].first[:status]).to eq("failed")
    expect(Rails.logger).to have_received(:warn)
      .with("Crawl failed for https://jp.mercari.com/search: RuntimeError: Unexpected page URL")
  end

  it "fails the URL when rendered HTML exceeds the size limit" do
    page = instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), url: "https://jp.mercari.com/search",
                                             content: "a" * (described_class::MAX_RESPONSE_BYTES + 1))
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(page.mouse).to receive(:wheel)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    allow(described_class).to receive(:sleep)

    result = ProductMonitoring::Crawler.call(params: { search_urls: ["https://jp.mercari.com/search?keyword=phone"] })
    expect(result[:sources].first[:status]).to eq("failed")
  end

  it "rejects a failed Mercari browser response" do
    page = instance_double(Playwright::Page)
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 403))
    allow(Crawl::Client).to receive(:execute).and_yield(page)

    expect { described_class.fetch_mercari_page(URI("https://jp.mercari.com/search?q=phone")) }
      .to raise_error(/Non-success HTTP response/)
  end

  it "follows only an available next page and preserves other query parameters" do
    uri = URI("https://jp.mercari.com/search?keyword=ipad%20pro&page_token=v1%3A2")
    expect(described_class.next_url(uri, Nokogiri::HTML("<html></html>"))).to be_nil
    next_uri = described_class.next_url(uri, Nokogiri::HTML('<button data-testid="pagination-next-button"></button>'))
    expect(URI.decode_www_form(next_uri.query).to_h).to include("page_token" => "v1:3")
    expect(URI.decode_www_form(next_uri.query).to_h).to include("keyword" => "ipad pro")
  end

  it "stops after the maximum number of pages" do
    uri = URI("https://jp.mercari.com/search?keyword=ipad%20pro&page_token=v1%3A2")
    allow(described_class).to receive(:fetch).and_return([[{ external_id: "one" }], uri])
    result = ProductMonitoring::Crawler.fetch(site: described_class, canonical_url: uri.to_s)
    expect(described_class).to have_received(:fetch).exactly(ProductMonitoring::Crawler::MAX_PAGES_PER_URL).times
    expect(result.size).to eq(ProductMonitoring::Crawler::MAX_PAGES_PER_URL)
  end

  describe ".fetch_detail" do
    it "parses a sold listing and its relative date" do
      html = <<~HTML
        <div data-testid="item-detail-container"><div data-testid="price">100</div>
        <div aligncontent="start"><svg></svg><span>2日前</span></div>※売り切れのためコメントできません</div>
      HTML
      allow(described_class).to receive(:fetch_mercari_page).and_return(html)
      expect(described_class.fetch_detail("m123")).to eq(sold: true, bought_date: 2.days.ago.beginning_of_day)
      expect(described_class).to have_received(:fetch_mercari_page).with(URI("https://jp.mercari.com/item/m123"))
    end

    it "distinguishes available, deleted, and unknown pages" do
      allow(described_class).to receive(:fetch_mercari_page).and_return(
        '<div data-testid="item-detail-container"><div data-testid="price">100</div></div>',
        '<div class="merEmptyState">削除</div>', "<html></html>"
      )
      expect(described_class.fetch_detail("m123")).to eq(sold: false, bought_date: nil)
      expect(described_class.fetch_detail("m123")).to eq(deleted: true)
      expect(described_class.fetch_detail("m123")).to eq({})
    end

    it "rejects an unsafe external ID" do
      expect { described_class.fetch_detail("../search") }.to raise_error(ArgumentError)
    end
  end
end
