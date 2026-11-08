require "rails_helper"

RSpec.describe ProductMonitoring::Crawler do
  it "最大 5 ページを取得し各ページを 100 出品に制限すること" do
    site = class_double(ProductMonitoring::Sites::Mercari)
    allow(site).to receive(:fetch) { |uri| [Array.new(110) { |i| "#{uri.query}-#{i}" }, uri] }
    result = described_class.fetch(site: site, canonical_url: "https://jp.mercari.com/search?q=x")
    expect(result.size).to eq(500)
    expect(site).to have_received(:fetch).exactly(5).times
  end

  it "空のページでも次ページがあれば取得を続けること" do
    site = class_double(ProductMonitoring::Sites::TreasureFactory)
    second = URI("https://ec.treasure-f.com/search?word=x&page=2")
    allow(site).to receive(:fetch).and_return([[], second], [[{ external_id: "a" }], nil])
    result = described_class.fetch(site: site, canonical_url: "https://ec.treasure-f.com/search?word=x")
    expect(result).to eq([{ external_id: "a" }])
    expect(site).to have_received(:fetch).with(second)
  end

  it "external_id で重複を除き共通の包含フィルターを適用すること" do
    allow(described_class).to receive(:fetch).and_return([
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "one" },
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "two" }
                                                         ])
    result = described_class.call(params: {
                                    search_urls: ["https://jp.mercari.com/search?q=x",
                                                  "https://jp.mercari.com/search?q=y"],
                                    min_price: "100", max_price: "100", required_keywords: ["phone"]
                                  })
    expect(result[:fetched_count]).to eq(1)
    expect(result[:accepted_count]).to eq(1)
  end

  it "不正な範囲を拒否すること" do
    expect { described_class.call(params: { min_price: "x", search_urls: [] }) }.to raise_error(ArgumentError, /価格/)
  end

  it "取得元の失敗を分離し未対応の URL を報告すること" do
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

  it "URL のクエリを除いて失敗を記録し公開エラーを維持すること" do
    allow(described_class).to receive(:fetch).and_raise(Timeout::Error, "timed out")
    allow(Rails.logger).to receive(:warn)
    result = described_class.call(params: { search_urls: ["https://jp.mercari.com/search?q=secret"] })
    expect(Rails.logger).to have_received(:warn)
      .with("Crawl failed for https://jp.mercari.com/search: Timeout::Error: timed out")
    expect(result[:sources].first[:error]).to eq("Crawl failed")
  end

  it "必須ワードの AND、除外ワードの OR、出品の除外を適用すること" do
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

  it "不正なキーワードパラメータを空のフィルターとして扱わないこと" do
    expect do
      described_class.call(params: { required_keywords: "phone", search_urls: [] })
    end.to raise_error(ArgumentError)
  end
end

RSpec.describe "検索語からのクロール" do
  it "全サイトの URL を検証し、ヤフオクの両方と追加 URL を取得すること" do
    allow(ProductMonitoring::Crawler).to receive(:fetch).and_return([])
    result = ProductMonitoring::Crawler.call(params: {
      keyword: "iPad Pro &", platforms: ProductMonitoring::UrlRouter::SITES.map { |site| site::PLATFORM },
      search_urls: ["https://iosys.co.jp/items?q=extra"], min_price: 100
    })
    expect(result[:sources].size).to eq(8)
    expect(result[:sources].pluck(:status)).to all(eq("succeeded"))
    urls = result[:sources].pluck(:url)
    expect(urls).to include("https://auctions.yahoo.co.jp/search/search?p=iPad+Pro+%26",
                            "https://auctions.yahoo.co.jp/closedsearch/closedsearch?p=iPad+Pro+%26",
                            "https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro%20%26")
    expect(urls).to include("https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro+%26")
  end
end
