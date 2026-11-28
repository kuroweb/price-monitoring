require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooAuction::ListPage::Parser do
  include ActiveSupport::Testing::TimeHelpers

  let(:active_uri) { URI("https://auctions.yahoo.co.jp/search/search?p=ipad&mode=2&n=100&abatch=1%2C2") }
  let(:closed_uri) { URI("https://auctions.yahoo.co.jp/closedsearch/closedsearch?p=ipad") }

  def item(price, span: "<span>11/07 12:00終了</span>")
    <<~HTML
      <li><div><a href="https://auctions.yahoo.co.jp/jp/auction/a123" class="wb_break-all">iPad</a>
        <a href="/seller/seller1">seller</a><img src="https://example.com/image.jpg">
        <div class="lg:grid-tc_1fr_160px">#{price}</div>#{span}
      </div></li>
    HTML
  end

  def listing(html, uri: active_uri)
    described_class.call(uri, Nokogiri::HTML(html)).first.first
  end

  it "出品中の価格と、落札相場の売れた日を読み取ること" do
    travel_to Time.zone.parse("2026-11-07 10:00") do
      active = listing(item("現在1,200円 即決2,000円"))
      closed = listing(item("落札1,500円"), uri: closed_uri)
      expect(active).to include(platform: "yahoo_auction", external_id: "a123", name: "iPad", price: 1200,
                                buyout_price: 2000, thumbnail_url: "https://example.com/image.jpg", sold: false,
                                sold_at: nil, ends_at: Time.zone.parse("2026-11-07 12:00"))
      expect(closed).to include(price: 1500, sold: true, sold_at: closed[:ends_at],
                                product_url: "https://auctions.yahoo.co.jp/jp/auction/a123")
    end
  end

  it "即決価格だけの出品は即決価格を価格にすること" do
    expect(listing(item("即決2,000円"))).to include(price: 2000, buyout_price: nil)
  end

  it "終了日時が読めないときは残り時間から終了日時を求めること" do
    travel_to Time.zone.parse("2026-11-07 10:00") do
      expect(listing(item("現在1,200円", span: "<span>1時間2分3秒</span>"))[:ends_at]).to eq(3723.seconds.from_now)
    end
  end

  it "入札件数と日付が隣接していても終了日時だけを読み取ること" do
    travel_to Time.zone.parse("2026-11-09 10:00") do
      html = item("落札1,000円", span: "<span>1</span><span><span>8/27 19:32<!-- -->終了</span></span>")
      expect(listing(html, uri: closed_uri)[:sold_at]).to eq(Time.zone.parse("2026-08-27 19:32"))
    end
  end

  it "次ページは開始位置を100件進め、検索条件を保つこと" do
    _, next_uri = described_class.call(active_uri, Nokogiri::HTML("#{item('現在1,200円')}<a href=\"?b=101\">次へ</a>"))
    expect(URI.decode_www_form(next_uri.query).to_h).to include("b" => "101", "p" => "ipad", "n" => "100")
  end

  it "検索結果が空なら結果を返さず、認識できないページは失敗にすること" do
    expect(described_class.call(active_uri, Nokogiri::HTML('<div class="Notice__wandQuery"></div>'))).to eq([[], nil])
    expect { described_class.call(active_uri, Nokogiri::HTML("<div>unexpected</div>")) }
      .to raise_error("Search page has no extractable listings")
  end

  describe "出品者ID" do
    def with_items(items, body = item("現在1,200円"))
      data = { props: { initialState: { search: { items: { listing: { items: } } } } } }
      %(<script id="__NEXT_DATA__" type="application/json">#{data.to_json}</script>#{body})
    end

    it "埋め込まれた検索結果のデータから、出品IDが一致する出品に出品者IDを付けること" do
      html = with_items([{ auctionId: "b999", seller: { userId: "other" } },
                         { auctionId: "a123", seller: { userId: "Ab_9" } }])
      expect(listing(html)).to include(external_id: "a123", seller_id: "Ab_9")
      closed = with_items([{ auctionId: "a123", seller: { userId: "Ab_9" } }], item("落札1,500円"))
      expect(listing(closed, uri: closed_uri)).to include(sold: true, seller_id: "Ab_9")
    end

    it "データが無い、形が違う、同じ出品IDに違う出品者IDがあるときは不明とし、出品は読み取ること" do
      [
        item("現在1,200円"),
        %(<script id="__NEXT_DATA__" type="application/json">{</script>#{item('現在1,200円')}),
        with_items("x"),
        with_items([{ auctionId: "a123", seller: "x" }]),
        with_items([{ auctionId: "a123", seller: { userId: "a" } }, { auctionId: "a123", seller: { userId: "b" } }])
      ].each do |html|
        expect(listing(html)).to include(external_id: "a123", price: 1200, seller_id: nil)
      end
    end
  end
end
