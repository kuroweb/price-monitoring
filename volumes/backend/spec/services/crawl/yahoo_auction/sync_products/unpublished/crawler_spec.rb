require "rails_helper"

RSpec.describe Crawl::YahooAuction::SyncProducts::Unpublished::Crawler, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  describe "#execute" do
    let(:yahoo_auction_crawl_setting) { instance_double(YahooAuctionCrawlSetting) }
    let(:product) { instance_double(Product, id: 3, yahoo_auction_crawl_setting:) }
    let(:url_generator) do
      instance_double(
        Crawl::YahooAuction::SyncProducts::Unpublished::UrlGenerator,
        generate: "https://auctions.yahoo.co.jp/closedsearch/closedsearch?b=1"
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::YahooAuction::SyncProducts::Unpublished::UrlGenerator).to receive(:new).and_return(url_generator)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    def closed_item_li(external_id:, name:, price:, end_text:, seller_id: "closed_seller")
      <<~HTML
        <li>
          <div>
            <div>
              <a href="https://auctions.yahoo.co.jp/jp/auction/#{external_id}">
                <img src="https://example.com/thumb/#{external_id}.jpg" alt="">
              </a>
            </div>
            <div class="lg:grid-tc_1fr_160px">
              <a class="wb_break-all" href="https://auctions.yahoo.co.jp/jp/auction/#{external_id}">#{name}</a>
              <span>落札#{price}円</span>
              <span>#{end_text}</span>
              <a href="https://auctions.yahoo.co.jp/seller/#{seller_id}">出品者</a>
            </div>
          </div>
        </li>
      HTML
    end

    context "落札相場一覧に終了商品がある場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            #{closed_item_li(
              external_id: 'b111',
              name: 'iPad Pro 落札品',
              price: '18,700',
              end_text: '11/3 00:07終了'
            )}
          </ul>
        HTML
      end

      it "終了商品としてパースすること" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results.size).to eq(1)
          expect(crawl_results.results[0]).to have_attributes(
            external_id: "b111",
            seller_id: "closed_seller",
            name: "iPad Pro 落札品",
            price: 18_700,
            buyout_price: nil,
            published: false,
            bought_date: Time.zone.local(2026, 11, 3, 0, 7, 0),
            end_date: Time.zone.local(2026, 11, 3, 0, 7, 0)
          )
        end
      end
    end

    context "1 月に前年 12 月終了の落札商品がある場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            #{closed_item_li(
              external_id: 'b222',
              name: '前年落札 iPad',
              price: '20,000',
              end_text: '12/28 10:00終了'
            )}
          </ul>
        HTML
      end

      it "終了日時を前年として解釈すること" do
        travel_to Time.zone.local(2026, 1, 5, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].bought_date).to eq(Time.zone.local(2025, 12, 28, 10, 0, 0))
        end
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { "<div>条件に一致する商品は見つかりませんでした</div>" }

      it "空の結果を返し例外にならないこと" do
        crawl_results = crawler.execute

        expect(crawl_results.results).to be_empty
      end
    end
  end
end
