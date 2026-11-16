require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Iosys::Listing::Crawler do
  let(:setting) { create(:product_crawl_setting, search_urls: ["https://iosys.co.jp/items?q=phone"]) }
  let(:pages) { {} }
  let(:visited) { [] }

  # 取得した URL に応じた HTML を返すページを開く
  def stub_browser(status: 200, final_url: nil)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute) do |**, &block|
      page = instance_double(Playwright::Page)
      allow(page).to receive(:goto) do |url|
        visited << url
        allow(page).to receive_messages(url: final_url || url, content: yield(URI(url)))
        instance_double(Playwright::Response, status:)
      end
      block.call(page)
    end
  end

  before do
    stub_browser do |uri|
      pages.fetch(URI.decode_www_form(uri.query).to_h.fetch("page", "1")) { raise "unexpected page" }
    end
  end

  def item(id, name: "Phone", price: "1,000円", image: '<img src="/photos/1.jpg">')
    %(<li class="item"><a href="/items/#{id}"></a>#{image}<span class="name">#{name}</span>) +
      %(<span class="price">#{price}</span></li>)
  end

  def next_link
    '<a class="page-link" rel="next"></a>'
  end

  it "一覧の出品を読み取り、遅延読み込みの画像と相対URLの画像を解決すること" do
    pages["1"] = item("phone/1", image: '<img src="/dummy.gif" data-src="https://cdn.example/1_S.jpg">') +
                 item("phone/2", price: "20,800円 (税込)", image: '<img src="/photos/no_photo_S.jpg">')
    result = described_class.call(product_crawl_setting: setting)
    expect(result[:listings]).to contain_exactly(
      include(platform: "iosys", external_id: "phone/1", price: 1000, sold: false,
              thumbnail_url: "https://cdn.example/1_S.jpg", product_url: "https://iosys.co.jp/items/phone/1"),
      include(external_id: "phone/2", price: 20_800, thumbnail_url: "https://iosys.co.jp/photos/no_photo_S.jpg")
    )
    expect(result[:complete]).to be true
  end

  it "価格帯の表示やDBの上限を超える価格は価格なしにすること" do
    pages["1"] = item("range", price: "65,800円～117,800円") + item("large", price: "2,147,483,648円")
    expect(described_class.call(product_crawl_setting: setting)[:listings].pluck(:price)).to eq([nil, nil])
  end

  it "明示的な空結果は成功とし、出品も空結果もないページは失敗にすること" do
    pages["1"] = '<div id="empty">該当する商品がありません</div>'
    expect(described_class.call(product_crawl_setting: setting)).to eq(listings: [], complete: true)

    pages["1"] = "<html>challenge</html>"
    allow(Rails.logger).to receive(:warn)
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn)
      .with("Crawl failed for https://iosys.co.jp/items: RuntimeError: Search page has no extractable listings")
  end

  it "次ページをたどり、他のクエリパラメータを保つこと" do
    pages["1"] = item("one") + next_link
    pages["2"] = item("two")
    expect(described_class.call(product_crawl_setting: setting)[:listings].pluck(:external_id)).to eq(%w[one two])
    expect(visited).to eq(["https://iosys.co.jp/items?q=phone", "https://iosys.co.jp/items?q=phone&page=2"])
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute).with(block_scripts: true).twice
  end

  it "途中のページで失敗したURLの出品は、取得できたページの分も使わないこと" do
    setting.update!(search_urls: ["https://iosys.co.jp/items?q=phone", "https://iosys.co.jp/items?q=case"])
    stub_browser do |uri|
      query = URI.decode_www_form(uri.query).to_h
      raise Timeout::Error if query["page"] == "2"

      query["q"] == "phone" ? item("first-page") + next_link : item("other-url")
    end
    allow(Rails.logger).to receive(:warn)
    expect(described_class.call(product_crawl_setting: setting))
      .to match(listings: [include(external_id: "other-url")], complete: false)
  end

  it "最大ページで打ち切ったときは、一覧を最後まで取得できなかったとすること" do
    (1..5).each { |n| pages[n.to_s] = item("item-#{n}") + next_link }
    result = described_class.call(product_crawl_setting: setting)
    expect(result[:listings].size).to eq(5)
    expect(result[:complete]).to be false
  end

  it "検索語のURLと追加URLのうちイオシスの分だけを取得すること" do
    setting.update!(keyword: "phone", platforms: %w[iosys mercari],
                    search_urls: ["https://iosys.co.jp/items?q=phone", "https://jp.mercari.com/search?keyword=x"])
    pages["1"] = item("one")
    described_class.call(product_crawl_setting: setting)
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute).twice
  end

  it "非 2xx の応答では接続し直して別のプロキシで試し、上限回数で失敗にすること" do
    allow(Kernel).to receive(:sleep)
    allow(Rails.logger).to receive(:warn)
    stub_browser(status: 403) { item("one") }
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute).exactly(described_class::FETCH_TRIES).times
  end

  it "別のホストへ移ったページと上限を超える HTML は、接続し直さずに失敗にすること" do
    allow(Rails.logger).to receive(:warn)
    stub_browser(final_url: "https://evil.example/items") { item("one") }
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn).with(/Unexpected page URL/)

    stub_browser { "x" * (described_class::MAX_RESPONSE_BYTES + 1) }
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn).with(/size limit/)
    expect(ProductMonitoring::Crawling::Client).to have_received(:execute).twice
  end

  it "検索結果URLが無ければ、一覧を取得できなかったとすること" do
    setting.update!(search_urls: ["https://jp.mercari.com/search?keyword=x"])
    expect(described_class.call(product_crawl_setting: setting)).to eq(listings: [], complete: false)
  end
end
