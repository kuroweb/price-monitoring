require "rails_helper"

RSpec.describe Crawl::YahooAuction::SyncProduct::Crawler, type: :service do
  describe ".call" do
    let(:yahoo_auction_product) do
      instance_double(
        YahooAuctionProduct,
        external_id: "w1215385260",
        seller_id: "old_seller",
        name: "old name",
        price: 48_906,
        buyout_price: nil,
        thumbnail_url: "https://example.com/old.jpg",
        published: true,
        bought_date: nil,
        end_date: Time.zone.local(2026, 5, 15, 18, 27, 0)
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }

    before do
      allow(Crawl::Client).to receive(:execute).and_yield(page)
    end

    context "商品詳細 JSON が取得できる場合" do
      let(:page_html) do
        <<~HTML
          <script id="__NEXT_DATA__" type="application/json">
            {
              "props": {
                "pageProps": {
                  "initialState": {
                    "item": {
                      "detail": {
                        "item": {
                          "status": "open",
                          "title": "Magic Keyboard",
                          "price": 12000,
                          "bidorbuy": 15000,
                          "bids": 2,
                          "endTime": "2026-11-10T10:45:00+09:00",
                          "seller": { "aucUserId": "new_seller" },
                          "img": [{ "thumbnail": "https://example.com/new.jpg" }]
                        }
                      }
                    }
                  }
                }
              }
            }
          </script>
        HTML
      end

      it "JSON から出品中商品としてパースする" do
        crawl_result = described_class.call(yahoo_auction_product:)

        expect(crawl_result).to have_attributes(
          external_id: "w1215385260",
          seller_id: "new_seller",
          name: "Magic Keyboard",
          price: 12_000,
          buyout_price: 15_000,
          thumbnail_url: "https://example.com/new.jpg",
          published: true,
          deletable: false
        )
        expect(crawl_result.end_date).to eq(Time.zone.parse("2026-11-10T10:45:00+09:00"))
      end
    end

    context "fetchItemDetailError がある場合" do
      let(:page_html) do
        <<~HTML
          <script id="__NEXT_DATA__" type="application/json">
            { "props": { "pageProps": { "initialState": { "item": { "fetchItemDetailError": true } } } } }
          </script>
        HTML
      end

      it "deletable な結果を返す" do
        crawl_result = described_class.call(yahoo_auction_product:)

        expect(crawl_result.deletable).to be(true)
      end
    end
  end
end
