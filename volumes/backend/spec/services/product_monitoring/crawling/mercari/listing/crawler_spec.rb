require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::Listing::Crawler do
  let(:url) { "https://jp.mercari.com/search?keyword=phone&sort=price" }
  let(:setting) { create(:product_crawl_setting, search_urls: [url]) }
  let(:page) { instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), url:) }
  let(:status) { 200 }

  def item(id)
    <<~HTML
      <li data-testid="item-cell"><a href="/item/#{id}"></a><span data-testid="thumbnail-item-name">Phone</span>
      <span data-testid="item-tile-price">¥1,200</span><img alt="Phoneのサムネイル 売り切れ"></li>
    HTML
  end

  def next_button
    '<button data-testid="pagination-next-button"></button>'
  end

  before do
    allow(page).to receive(:goto) { instance_double(Playwright::Response, status:) }
    allow(page).to receive(:content).and_return(item("item-1"))
    allow(page.mouse).to receive(:wheel)
    allow(page).to receive(:evaluate).with(described_class::RENDERED_SCRIPT).and_return(false, true)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).and_yield(page)
    allow(Kernel).to receive(:sleep)
    allow(Rails.logger).to receive(:warn)
  end

  it "描画してスクロールした一覧から出品を読み取ること" do
    result = described_class.call(product_crawl_setting: setting)
    expect(result).to eq(complete: true, listings: [
                           { platform: "mercari", external_id: "item-1", name: "Phone", price: 1200, sold: true,
                             product_url: "https://jp.mercari.com/item/item-1",
                             thumbnail_url: "https://static.mercdn.net/thumb/item/webp/item-1_1.jpg" }
                         ])
    expect(page).to have_received(:goto).with(url)
  end

  it "次ページのボタンがあれば page_token を進め、他のクエリパラメータを保つこと" do
    allow(page).to receive(:content).and_return("#{item('one')}#{next_button}", item("two"))
    expect(described_class.call(product_crawl_setting: setting)[:listings].pluck(:external_id)).to eq(%w[one two])
    expect(page).to have_received(:goto).with("https://jp.mercari.com/search?keyword=phone&sort=price&page_token=v1%3A1")
  end

  it "メルカリの1ページ120件はすべて取得し、最大5ページで止めたら一覧を最後まで取得できなかったとすること" do
    contents = Array.new(5) { |page_number| "#{Array.new(120) { |n| item("#{page_number}-#{n}") }.join}#{next_button}" }
    allow(page).to receive(:content).and_return(*contents)
    result = described_class.call(product_crawl_setting: setting)
    expect(result[:listings].size).to eq(600)
    expect(result[:complete]).to be false
    expect(page).to have_received(:goto).exactly(5).times
  end

  it "セルが描画されるまでスクロールし、描画しきれなければ一覧を最後まで取得できなかったとすること" do
    expect(described_class.call(product_crawl_setting: setting)).to include(complete: true)
    expect(page.mouse).to have_received(:wheel).once

    allow(page).to receive(:evaluate).and_return(false)
    expect(described_class.call(product_crawl_setting: setting)).to include(complete: false)
    expect(page.mouse).to have_received(:wheel).exactly(1 + described_class::MAX_SCROLLS).times
  end

  it "1ページの上限を超えた分は取得せず、一覧を最後まで取得できなかったとすること" do
    max = described_class::MAX_RESULTS_PER_PAGE
    allow(page).to receive(:content).and_return(Array.new(max + 1) { |n| item("over-#{n}") }.join)
    result = described_class.call(product_crawl_setting: setting)
    expect(result[:listings].size).to eq(max)
    expect(result[:complete]).to be false
  end

  it "空結果は成功とし、出品も空結果もないページは失敗にすること" do
    allow(page).to receive(:content).and_return('<div class="merEmptyState">出品がありません</div>')
    expect(described_class.call(product_crawl_setting: setting)).to eq(listings: [], complete: true)
    allow(page).to receive(:content).and_return("<html></html>")
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
  end

  it "別ホストへの遷移はクエリを伏せたURLで失敗として記録すること" do
    allow(page).to receive(:url).and_return("https://example.com/")
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
    expect(Rails.logger).to have_received(:warn)
      .with("Crawl failed for https://jp.mercari.com/search: RuntimeError: Unexpected page URL")
  end

  context "サイトが成功以外の応答を返したとき" do
    let(:status) { 403 }

    it "失敗として記録すること" do
      expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
      expect(Rails.logger).to have_received(:warn).with(/Non-success HTTP response/)
    end
  end

  it "描画後の HTML がサイズの上限を超えたら失敗にすること" do
    allow(page).to receive(:content).and_return("a" * ((10 * 1024 * 1024) + 1))
    expect { described_class.call(product_crawl_setting: setting) }.to raise_error("All search URLs failed")
  end
end
