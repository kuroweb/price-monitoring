require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::DetailPage::Crawler do
  let(:status) { 200 }
  let(:page) do
    instance_double(Playwright::Page, mouse: instance_double(Playwright::Mouse), url: "https://jp.mercari.com/item/m123")
  end

  before do
    allow(page).to receive(:goto).and_return(instance_double(Playwright::Response, status:))
    allow(page.mouse).to receive(:wheel)
    allow(ProductMonitoring::Crawling::Client).to receive(:execute).and_yield(page)
    allow(Kernel).to receive(:sleep)
  end

  def stub_contents(*htmls)
    allow(page).to receive(:content).and_return(*htmls)
  end

  it "売り切れの出品と、相対表示の売れた日を読み取ること" do
    stub_contents(<<~HTML)
      <script type="application/ld+json">{"@graph":[{"@type":"Product","offers":{"availability":"https://schema.org/SoldOut"}}]}</script>
      <div data-testid="item-detail-container"><div data-testid="price">100</div>
      <div aligncontent="start"><svg></svg><span>2日前</span></div>※売り切れのためコメントできません</div>
      <script>const text = "ページが見つかりませんでした";</script>
    HTML
    expect(described_class.call(external_id: "m123")).to eq(sold: true, sold_at: 2.days.ago.beginning_of_day)
    expect(page).to have_received(:goto).with("https://jp.mercari.com/item/m123")
  end

  it "出品中、削除済み、判定できないページを区別すること" do
    stub_contents(
      '<script type="application/ld+json">{"@type":"Product",' \
      '"offers":{"availability":"https://schema.org/InStock"}}</script>' \
      '<div data-testid="item-detail-container"><div data-testid="price">100</div>' \
      "<div>該当する商品は削除されています。 ページが見つかりませんでした ※売り切れのためコメントできません</div></div>",
      '<div class="merEmptyState">削除</div>', "<html></html>"
    )
    expect(described_class.call(external_id: "m123")).to eq(sold: false, sold_at: nil)
    expect(described_class.call(external_id: "m123")).to eq(deleted: true)
    expect(described_class.call(external_id: "m123")).to eq({})
  end

  it "在庫状態を読み取れないときは販売状態を推測しないこと" do
    stub_contents(
      '<div data-testid="item-detail-container"><div data-testid="price">100</div></div>',
      '<script type="application/ld+json">invalid</script>' \
      '<div data-testid="item-detail-container"><div data-testid="price">100</div></div>'
    )
    expect(described_class.call(external_id: "m123")).to eq({})
    expect(described_class.call(external_id: "m123")).to eq({})
  end

  it "安全でない出品IDを拒否すること" do
    expect { described_class.call(external_id: "../search") }.to raise_error(ArgumentError)
  end

  context "個別ページが404を返したとき" do
    let(:status) { 404 }
    let(:not_found_html) do
      <<~HTML
        <h1>ページが見つかりませんでした</h1>
        <p>お探しのページはURLが間違っているか、削除された可能性があります。</p>
      HTML
    end

    it "対象出品の不存在表示を確認できたときだけ削除結果を返すこと" do
      stub_contents(not_found_html)
      expect(described_class.call(external_id: "m123")).to eq(deleted: true)
    end

    it "汎用の404、スクリプト内の文言、商品詳細がある画面では失敗すること" do
      [
        '<div class="merEmptyState">ページが見つかりませんでした</div>',
        "<script>#{not_found_html}</script>",
        "#{not_found_html}<div data-testid='item-detail-container'></div>"
      ].each do |html|
        stub_contents(html)
        expect { described_class.call(external_id: "m123") }.to raise_error("Non-success HTTP response")
      end
    end

    it "別の出品へ遷移したときは削除結果を返さないこと" do
      allow(page).to receive(:url).and_return("https://jp.mercari.com/item/m456")
      stub_contents(not_found_html)
      expect { described_class.call(external_id: "m123") }.to raise_error("Unexpected page URL")
    end

    it "応答がサイズ上限を超えるときは失敗すること" do
      stub_contents(not_found_html + (" " * described_class::MAX_RESPONSE_BYTES))
      expect { described_class.call(external_id: "m123") }.to raise_error("Response exceeds size limit")
    end
  end

  [403, 429, 500].each do |error_status|
    context "個別ページが#{error_status}を返したとき" do
      let(:status) { error_status }

      it "本文を判定せず失敗すること" do
        allow(page).to receive(:content)
        expect { described_class.call(external_id: "m123") }.to raise_error("Non-success HTTP response")
        expect(page).not_to have_received(:content)
      end
    end
  end
end
