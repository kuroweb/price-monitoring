require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::DetailPage::Crawler do
  include ActiveSupport::Testing::TimeHelpers

  let(:page) { instance_double(Playwright::Page, url: "https://paypayfleamarket.yahoo.co.jp/item/z123") }
  let(:status) { 200 }

  before do
    allow(page).to receive(:goto) { instance_double(Playwright::Response, status:) }
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).and_yield(page)
    allow(Kernel).to receive(:sleep)
  end

  def detail(availability, updated = nil)
    html = %(<script type="application/ld+json">{"@type":"Product","offers":{"availability":"https://schema.org/#{availability}"}}</script>)
    html += %(<aside><img alt="時計アイコン"><span>#{updated}</span></aside>) if updated
    allow(page).to receive(:content).and_return(html)
    described_class.call(external_id: "z123")
  end

  it "販売者の文言ではなく商品の構造化データから在庫状態を判定すること" do
    allow(page).to receive(:content).and_return('<div>売り切れ</div><script type="application/ld+json">' \
                                                '{"@type":"Product","offers":{"availability":"https://schema.org/InStock"}}</script>')
    expect(described_class.call(external_id: "z123")).to eq(sold: false, sold_at: nil)
    allow(page).to receive(:content).and_return("<div>売り切れ</div>")
    expect(described_class.call(external_id: "z123")).to eq({})
  end

  it "売り切れの出品は、日・週・月単位の更新表示から売れた日を推定すること" do
    travel_to Time.current.change(usec: 0) do
      expect(detail("OutOfStock", "2日前に更新")).to eq(sold: true, sold_at: 2.days.ago.beginning_of_day)
      expect(detail("OutOfStock", "3週間前に更新")[:sold_at]).to eq(3.weeks.ago.beginning_of_day)
      expect(detail("OutOfStock", "1ヶ月前に更新")[:sold_at]).to eq(1.month.ago.beginning_of_day)
    end
  end

  context "個別ページが 404 を返したとき" do
    let(:status) { 404 }
    let(:not_found_html) { "<main><aside><div><span>この商品は存在しません</span></div></aside></main>" }

    it "対象出品の不存在表示を確認できたときに削除結果を返すこと" do
      allow(page).to receive(:content).and_return(not_found_html)
      expect(described_class.call(external_id: "z123")).to eq(deleted: true)
    end

    it "汎用の404、表示領域外やスクリプト内の文言、商品データがあるページでは失敗すること" do
      [
        "<main><aside><span>Not Found</span></aside></main>",
        "<main><article><span>この商品は存在しません</span></article></main>",
        "<main><aside><span><script>この商品は存在しません</script></span></aside></main>",
        %(#{not_found_html}<script type="application/ld+json">{"@type":"Product"}</script>)
      ].each do |html|
        allow(page).to receive(:content).and_return(html)
        expect { described_class.call(external_id: "z123") }.to raise_error("Non-success HTTP response")
      end
    end

    it "別の出品へ遷移したときは失敗すること" do
      allow(page).to receive(:url).and_return("https://paypayfleamarket.yahoo.co.jp/item/z456")
      expect { described_class.call(external_id: "z123") }.to raise_error("Unexpected page URL")
    end
  end

  context "個別ページが 429 を返したとき" do
    let(:status) { 429 }

    it "本文を判定せず失敗すること" do
      allow(page).to receive(:content)
      expect { described_class.call(external_id: "z123") }.to raise_error("Non-success HTTP response")
      expect(page).not_to have_received(:content)
    end
  end
end
