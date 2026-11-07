require "rails_helper"

RSpec.describe ProductMonitoring::Sites::TreasureFactory do
  let(:uri) { URI("https://ec.treasure-f.com/search?category=1029&word=macbook&number=90") }

  def item_html(id:, price: nil, image: %(src="/images/#{id}/340/#{id}_01.jpeg"), alt: "Apple (アップル) MacBook Air")
    price_html = price ? %(<div><p class="cm-itemlist_price is-sale">#{price}</p></div>) : ""
    soldout_html = price ? "" : '<span class="cm-itemlist_soldout"><i>SOLD OUT</i></span>'
    <<~HTML
      <li class="pj-search_item"><a class="cm-itemlist_itemcode_link" href="/item/#{id}">
      <div class="cm-itemlist_image"><img #{image} alt="#{alt}">#{soldout_html}</div>
      <div class="cm-itemlist_text_wrap"><p class="cm-itemlist_text">Apple(アップル)</p>
      <p class="cm-itemlist_text">MacBook Air</p></div>#{price_html}</a></li>
    HTML
  end

  def stub_page(html)
    allow(described_class).to receive(:fetch_page).and_return(Struct.new(:body).new(html))
  end

  it "販売中の出品を抽出し、売り切れの出品と次ページを判定すること" do
    stub_page(<<~HTML)
      <ul>#{item_html(id: '1082002574368733', price: '￥68,200')}
      #{item_html(id: '1004019920556004', image: 'class="image-lazyload" data-src="/images/2.jpeg"')}</ul>
      <ul class="cm-pagination"><li><a href="https://ec.treasure-f.com/search?page=2" rel="next"></a></li></ul>
    HTML
    results, next_uri = described_class.fetch(uri)
    expect(results).to contain_exactly(
      external_id: "1082002574368733", name: "Apple (アップル) MacBook Air", price: 68_200, sold: false,
      product_url: "https://ec.treasure-f.com/item/1082002574368733",
      thumbnail_url: "https://ec.treasure-f.com/images/1082002574368733/340/1082002574368733_01.jpeg"
    )
    expect(URI.decode_www_form(next_uri.query).to_h).to include("word" => "macbook", "number" => "90", "page" => "2")
  end

  it "遅延読み込みの画像 URL を使い、代替テキストがなければ一覧の表示名を使うこと" do
    stub_page(item_html(id: "1", price: "￥1,000", image: 'src="/dummy.gif" data-src="/images/1.jpeg"', alt: ""))
    result = described_class.fetch(uri).first.first
    expect(result).to include(name: "Apple(アップル) MacBook Air", thumbnail_url: "https://ec.treasure-f.com/images/1.jpeg")
  end

  it "最終ページでは次ページを返さず、明示的な空結果と売り切れだけのページを認識し不明なページを拒否すること" do
    stub_page(item_html(id: "1", price: "￥1,000"))
    expect(described_class.fetch(uri).last).to be_nil
    stub_page('<div class="pj-search_not_found"><h3>ご指定の条件に一致する商品がありませんでした。</h3></div>')
    expect(described_class.fetch(uri)).to eq([[], nil])
    stub_page(item_html(id: "2"))
    expect(described_class.fetch(uri)).to eq([[], nil])
    stub_page("<html>challenge</html>")
    expect { described_class.fetch(uri) }.to raise_error(/no extractable listings/)
  end

  it "サイズ上限つきで HTTPS の検索ページを取得すること" do
    allow(ProductMonitoring::Sites::HttpPage).to receive(:fetch).and_return(:response)
    expect(described_class.fetch_page(uri)).to eq(:response)
    expect(ProductMonitoring::Sites::HttpPage).to have_received(:fetch)
      .with(uri, max_bytes: described_class::MAX_RESPONSE_BYTES)
  end

  describe "URL の振り分け" do
    it "クエリつきの検索 URL だけを振り分け、詳細は確認しないこと" do
      expect(ProductMonitoring::UrlRouter.call(url: uri.to_s))
        .to include(platform: "treasure_factory", site: described_class)
      expect(ProductMonitoring::UrlRouter.detail_site("treasure_factory")).to be_nil
      %w[https://ec.treasure-f.com/search https://ec.treasure-f.com/item/1?x=1
         https://treasure-f.com/search?word=x http://ec.treasure-f.com/search?word=x].each do |invalid|
        expect { ProductMonitoring::UrlRouter.call(url: invalid) }.to raise_error(ArgumentError)
      end
    end
  end
end
