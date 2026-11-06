require "rails_helper"

RSpec.describe ProductMonitoring::Sites::Mercari do
  it "extracts actual HTML and preserves the listing URL and query" do
    html = <<~HTML
      <li data-testid="item-cell"><a href="/item/item-1"></a><span data-testid="thumbnail-item-name">Phone</span>
      <span data-testid="item-tile-price">¥1,200</span></li>
    HTML
    allow(described_class).to receive(:fetch_mercari_page).and_return(html)
    url = "https://jp.mercari.com/search?q=phone&sort=price"
    result = ProductMonitoring::Crawler.call(params: { search_urls: [url] })
    expect(described_class).to have_received(:fetch_mercari_page).with(URI("https://jp.mercari.com/search?q=phone&sort=price"))
    expect(result[:results].first).to include(external_id: "item-1", price: 1200,
                                              thumbnail_url: "https://static.mercdn.net/thumb/item/webp/item-1_1.jpg",
                                              product_url: "https://jp.mercari.com/item/item-1")
  end

  it "renders the Mercari search page with the existing browser client" do
    page = instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), content: "<html></html>")
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status: 200))
    allow(page.mouse).to receive(:wheel)
    allow(Crawl::Client).to receive(:execute).and_yield(page)
    allow(described_class).to receive(:sleep)

    expect(described_class.fetch_mercari_page(URI("https://jp.mercari.com/search?q=phone"))).to eq("<html></html>")
    expect(page).to have_received(:goto).with("https://jp.mercari.com/search?q=phone")
    expect(page.mouse).to have_received(:wheel).exactly(30).times
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
end
