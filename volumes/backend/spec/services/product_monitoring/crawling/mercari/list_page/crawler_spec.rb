require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::ListPage::Crawler do
  let(:url) { "https://jp.mercari.com/search?keyword=phone&sort=price" }
  let(:setting) { create(:product_monitoring_crawl_setting, search_urls: [url]) }
  let(:page) { instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), url:) }
  let(:status) { 200 }
  let(:search_api_url) { "https://api.mercari.jp/v2/entities:search" }
  # 実際のブラウザでは goto の間に応答イベントが届くため、goto の中で受け手へ渡す
  let(:responses) { [] }

  def item(id)
    <<~HTML
      <li data-testid="item-cell"><a href="/item/#{id}"></a><span data-testid="thumbnail-item-name">Phone</span>
      <span data-testid="item-tile-price">¥1,200</span><img alt="Phoneのサムネイル 売り切れ"></li>
    HTML
  end

  def next_button
    '<button data-testid="pagination-next-button"></button>'
  end

  def api_response(items, url: search_api_url, status: 200)
    instance_double(Playwright::Response, url:, status:, body: { items: }.to_json)
  end

  before do
    listeners = []
    allow(page).to receive(:on).with("response", anything) { |_, listener| listeners << listener }
    allow(page).to receive(:goto) do
      responses.each { |response| listeners.each { |listener| listener.call(response) } }
      instance_double(Playwright::Response, status:)
    end
    allow(page).to receive(:content).and_return(item("item-1"))
    allow(page.mouse).to receive(:wheel)
    allow(page).to receive(:evaluate).with(described_class::RENDERED_SCRIPT).and_return(false, true)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).and_yield(page)
    allow(Kernel).to receive(:sleep)
    allow(Rails.logger).to receive(:warn)
  end

  it "描画してスクロールした一覧から出品を読み取ること" do
    result = described_class.call(crawl_setting: setting)
    expect(result).to eq(complete: true, listings: [
                           { platform: "mercari", external_id: "item-1", name: "Phone", price: 1200, sold: true,
                             seller_id: nil, product_url: "https://jp.mercari.com/item/item-1",
                             thumbnail_url: "https://static.mercdn.net/thumb/item/webp/item-1_1.jpg" }
                         ])
    expect(page).to have_received(:goto).with(url)
  end

  it "次ページのボタンがあれば page_token を進め、他のクエリパラメータを保つこと" do
    allow(page).to receive(:content).and_return("#{item('one')}#{next_button}", item("two"))
    expect(described_class.call(crawl_setting: setting)[:listings].pluck(:external_id)).to eq(%w[one two])
    expect(page).to have_received(:goto).with("https://jp.mercari.com/search?keyword=phone&sort=price&page_token=v1%3A1")
  end

  it "メルカリの1ページ120件はすべて取得し、最大5ページで止めたら一覧を最後まで取得できなかったとすること" do
    contents = Array.new(5) { |page_number| "#{Array.new(120) { |n| item("#{page_number}-#{n}") }.join}#{next_button}" }
    allow(page).to receive(:content).and_return(*contents)
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings].size).to eq(600)
    expect(result[:complete]).to be false
    expect(page).to have_received(:goto).exactly(5).times
  end

  it "セルが描画されるまでスクロールし、描画しきれなければ一覧を最後まで取得できなかったとすること" do
    expect(described_class.call(crawl_setting: setting)).to include(complete: true)
    expect(page.mouse).to have_received(:wheel).once

    allow(page).to receive(:evaluate).and_return(false)
    expect(described_class.call(crawl_setting: setting)).to include(complete: false)
    expect(page.mouse).to have_received(:wheel).exactly(1 + described_class::MAX_SCROLLS).times
  end

  it "1ページの上限を超えた分は取得せず、一覧を最後まで取得できなかったとすること" do
    max = described_class::MAX_RESULTS_PER_PAGE
    allow(page).to receive(:content).and_return(Array.new(max + 1) { |n| item("over-#{n}") }.join)
    result = described_class.call(crawl_setting: setting)
    expect(result[:listings].size).to eq(max)
    expect(result[:complete]).to be false
  end

  it "空結果は成功とし、出品も空結果もないページは失敗にすること" do
    allow(page).to receive(:content).and_return('<div class="merEmptyState">出品がありません</div>')
    expect(described_class.call(crawl_setting: setting)).to eq(listings: [], complete: true)
    allow(page).to receive(:content).and_return("<html></html>")
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
  end

  it "別ホストへの遷移はクエリを伏せたURLで失敗として記録すること" do
    allow(page).to receive(:url).and_return("https://example.com/")
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn)
      .with("Crawl failed for https://jp.mercari.com/search: RuntimeError: Unexpected page URL")
  end

  context "サイトが成功以外の応答を返したとき" do
    let(:status) { 403 }

    it "失敗として記録すること" do
      expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
      expect(Rails.logger).to have_received(:warn).with(/Non-success HTTP response/)
    end
  end

  it "描画後の HTML がサイズの上限を超えたら失敗にすること" do
    allow(page).to receive(:content).and_return("a" * ((10 * 1024 * 1024) + 1))
    expect { described_class.call(crawl_setting: setting) }.to raise_error("All search URLs failed")
  end

  describe "出品者ID" do
    def respond_on_goto
      listener = nil
      allow(page).to receive(:on).with("response", anything) { |_, callback| listener = callback }
      allow(page).to receive(:goto) do |goto_url|
        listener.call(api_response(yield(goto_url)))
        instance_double(Playwright::Response, status:)
      end
    end

    it "同じページの描画で受け取った検索 API の応答から、出品IDが一致する出品に出品者IDを付けること" do
      responses << api_response([{ id: "item-1", sellerId: "Seller_1" }, { id: "other", sellerId: "2" }])
      expect(described_class.call(crawl_setting: setting)[:listings])
        .to contain_exactly(include(external_id: "item-1", seller_id: "Seller_1"))
    end

    it "数値の出品者IDも文字列にし、ページごとにそのページの応答から付けること" do
      allow(page).to receive(:content).and_return("#{item('one')}#{next_button}", item("two"))
      respond_on_goto do |goto_url|
        goto_url.include?("page_token") ? [{ id: "two", sellerId: 222 }] : [{ id: "one", sellerId: 111 }]
      end
      listings = described_class.call(crawl_setting: setting)[:listings]
      sellers = listings.to_h { |listing| listing.values_at(:external_id, :seller_id) }
      expect(sellers).to eq("one" => "111", "two" => "222")
    end

    it "検索 API 以外の応答、成功以外の応答、形式の違う出品者IDは使わないこと" do
      responses << api_response([{ id: "item-1", sellerId: "a" }], url: "https://api.mercari.jp/v2/other")
      responses << api_response([{ id: "item-1", sellerId: "b" }], url: "https://evil.example/v2/entities:search")
      responses << api_response([{ id: "item-1", sellerId: "c" }], status: 500)
      responses << api_response([{ id: "item-1", sellerId: "bad id" }])
      expect(described_class.call(crawl_setting: setting)[:listings]).to contain_exactly(include(seller_id: nil))
    end

    it "同じ出品IDに違う出品者IDがあるときは不明とすること" do
      responses << api_response([{ id: "item-1", sellerId: "a" }])
      responses << api_response([{ id: "item-1", sellerId: "b" }])
      expect(described_class.call(crawl_setting: setting)[:listings]).to contain_exactly(include(seller_id: nil))
    end

    it "応答を読めないときは出品者IDを不明とし、一覧の取得は続けること" do
      broken = instance_double(Playwright::Response, url: search_api_url, status: 200)
      allow(broken).to receive(:body).and_raise(Playwright::Error.new(message: "No resource with given identifier"))
      responses << broken
      responses << instance_double(Playwright::Response, url: search_api_url, status: 200, body: "{")
      responses << instance_double(Playwright::Response, url: search_api_url, status: 200, body: '{"items":"x"}')
      result = described_class.call(crawl_setting: setting)
      expect(result).to include(complete: true)
      expect(result[:listings]).to contain_exactly(include(external_id: "item-1", seller_id: nil))
      expect(Rails.logger).to have_received(:warn).with(/Mercari seller ids unavailable/).twice
    end

    it "応答が無いときは出品者IDを不明とすること" do
      expect(described_class.call(crawl_setting: setting)[:listings]).to contain_exactly(include(seller_id: nil))
    end
  end
end
