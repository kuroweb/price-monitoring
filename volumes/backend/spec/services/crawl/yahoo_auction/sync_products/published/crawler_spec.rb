require "rails_helper"

module YahooAuctionPublishedCrawlerSpecHelper
  module_function

  PUBLISHED_ITEM_LI = <<~HTML.freeze
    <li>
      <div>
        <div>
          <a href="https://auctions.yahoo.co.jp/jp/auction/%<external_id>s">
            %<img_html>s
          </a>
        </div>
        <div class="lg:grid-tc_1fr_160px">
          <a class="wb_break-all" href="https://auctions.yahoo.co.jp/jp/auction/%<external_id>s">%<name>s</a>
          <span>%<price_text>s</span>
          <span>%<end_text>s</span>
          <a href="https://auctions.yahoo.co.jp/seller/%<seller_id>s">出品者</a>
        </div>
      </div>
    </li>
  HTML

  def published_item_li(**attrs)
    external_id = attrs.fetch(:external_id)
    format(
      PUBLISHED_ITEM_LI,
      external_id:,
      name: attrs.fetch(:name),
      price_text: attrs.fetch(:price_text),
      end_text: attrs.fetch(:end_text),
      seller_id: attrs.fetch(:seller_id, "seller123"),
      img_html: attrs[:img_html] || %(<img src="https://example.com/thumb/#{external_id}.jpg" alt="">)
    )
  end

  def search_list(items_html, next_page: false)
    next_link = next_page ? '<a href="https://auctions.yahoo.co.jp/search/search?b=101">次へ</a>' : ""
    <<~HTML
      <ul>
        #{items_html}
      </ul>
      #{next_link}
    HTML
  end
end

RSpec.describe Crawl::YahooAuction::SyncProducts::Published::Crawler, type: :service do
  include ActiveSupport::Testing::TimeHelpers
  include YahooAuctionPublishedCrawlerSpecHelper

  describe "#execute" do
    let(:yahoo_auction_crawl_setting) { instance_double(YahooAuctionCrawlSetting) }
    let(:product) { instance_double(Product, id: 3, yahoo_auction_crawl_setting:) }
    let(:url_generator) do
      instance_double(
        Crawl::YahooAuction::SyncProducts::Published::UrlGenerator,
        generate: "https://auctions.yahoo.co.jp/search/search?b=1"
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::YahooAuction::SyncProducts::Published::UrlGenerator).to receive(:new).and_return(url_generator)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
      allow(Retryable).to receive(:retryable).and_yield
    end

    context "開催中一覧に即決のみ・現在+即決・出品者なしセルが混在する場合" do
      let(:page_html) do
        search_list(<<~HTML)
          #{published_item_li(
            external_id: 'n111',
            name: 'Magic Keyboard',
            price_text: '即決17,900円',
            end_text: '7日（11/10 10:45終了予定）'
          )}
          #{published_item_li(
            external_id: 'n222',
            name: 'iPad Pro ケース',
            price_text: '現在40,000円 即決45,000円',
            end_text: '（11/09 21:45終了予定）'
          )}
          <li><div><div><span>広告</span></div></div></li>
        HTML
      end

      it "出品中商品だけが順序どおり返る" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results.size).to eq(2)
          expect(crawl_results.results[0]).to have_attributes(
            external_id: "n111",
            seller_id: "seller123",
            name: "Magic Keyboard",
            price: 17_900,
            buyout_price: nil,
            thumbnail_url: "https://example.com/thumb/n111.jpg",
            published: true,
            end_date: Time.zone.local(2026, 11, 10, 10, 45, 0)
          )
          expect(crawl_results.results[1]).to have_attributes(
            external_id: "n222",
            name: "iPad Pro ケース",
            price: 40_000,
            buyout_price: 45_000,
            end_date: Time.zone.local(2026, 11, 9, 21, 45, 0)
          )
        end
      end
    end

    context "終了日時が相対表示（分・秒）のみの場合" do
      let(:page_html) do
        search_list(<<~HTML)
          <li>
            <div>
              <div>
                <a href="https://auctions.yahoo.co.jp/jp/auction/n888">
                  <img src="https://example.com/thumb/n888.jpg" alt="">
                </a>
                <span>もうすぐ終了</span>
              </div>
              <div class="lg:grid-tc_1fr_160px">
                <a class="wb_break-all" href="https://auctions.yahoo.co.jp/jp/auction/n888">iPad ケース</a>
                <span>即決10,978円</span>
                <span>21分40秒</span>
                <a href="https://auctions.yahoo.co.jp/seller/seller123">出品者</a>
              </div>
            </div>
          </li>
        HTML
      end

      it "残り時間の葉要素から終了日時を算出する" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].end_date).to eq(Time.zone.local(2026, 11, 3, 12, 21, 40))
        end
      end
    end

    context "商品名に分表記があり、終了日時の葉要素が無い場合" do
      let(:page_html) do
        search_list(
          published_item_li(
            external_id: "n890",
            name: "iPad 30分充電対応ケース",
            price_text: "現在10,000円",
            end_text: "送料無料"
          )
        )
      end

      it "商品名から終了日時を作らず end_date が nil のままである" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].end_date).to be_nil
        end
      end
    end

    context "12 月に翌年 1 月終了の開催中商品がある場合" do
      let(:page_html) do
        search_list(
          published_item_li(
            external_id: "n555",
            name: "年またぎ iPad",
            price_text: "現在10,000円",
            end_text: "（01/15 10:00終了予定）"
          )
        )
      end

      it "終了日時を翌年として解釈する" do
        travel_to Time.zone.local(2026, 12, 20, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].end_date).to eq(Time.zone.local(2027, 1, 15, 10, 0, 0))
        end
      end
    end

    context "img の src が無く srcset だけある場合" do
      let(:page_html) do
        search_list(
          published_item_li(
            external_id: "n666",
            name: "srcset サムネ",
            price_text: "現在8,000円",
            end_text: "（11/03 18:00終了予定）",
            img_html: '<img src="" srcset="https://example.com/thumb/from-srcset.jpg 1x" alt="">'
          )
        )
      end

      it "srcset からサムネイル URL を取得する" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].thumbnail_url).to eq("https://example.com/thumb/from-srcset.jpg")
        end
      end
    end

    context "旧 DOM (li.Product) で商品セルが 0 件の場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            <li class="Product">
              <a class="Product__titleLink" data-auction-id="old">旧 HTML</a>
            </li>
          </ul>
        HTML
      end

      it "ProductListHtmlMismatchError を raise する" do
        expect { crawler.execute }.to raise_error(Crawl::YahooAuction::SyncProducts::ProductListHtmlMismatchError)
      end
    end

    context "商品セルはあるが価格が解釈できず 0 件になる場合" do
      let(:page_html) do
        search_list(
          published_item_li(
            external_id: "n777",
            name: "価格不明",
            price_text: "送料無料のみ",
            end_text: "（11/03 18:00終了予定）"
          )
        )
      end

      it "ProductListHtmlMismatchError を raise する" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          expect { crawler.execute }.to raise_error(Crawl::YahooAuction::SyncProducts::ProductListHtmlMismatchError)
        end
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { "<div>条件に一致する商品は見つかりませんでした</div>" }

      it "空の結果を返し例外にならない" do
        crawl_results = crawler.execute

        expect(crawl_results.results).to be_empty
      end
    end

    context "次へリンクがある場合" do
      let(:first_page_html) do
        search_list(
          published_item_li(
            external_id: "n333",
            name: "1 ページ目",
            price_text: "現在10,000円",
            end_text: "（11/03 18:00終了予定）"
          ),
          next_page: true
        )
      end
      let(:second_page_html) do
        search_list(
          published_item_li(
            external_id: "n334",
            name: "2 ページ目",
            price_text: "現在11,000円",
            end_text: "（11/04 18:00終了予定）"
          ),
          next_page: false
        )
      end
      let(:page) do
        Class.new(CrawlFakePlaywrightPage) do
          define_method(:initialize) do |first_html, second_html|
            @first_html = first_html
            @second_html = second_html
            super(first_html)
          end

          def goto(url)
            @goto_urls << url
            @doc = Nokogiri::HTML(@goto_urls.size <= 1 ? @first_html : @second_html)
          end
        end.new(first_page_html, second_page_html)
      end

      it "2 ページ目まで goto する" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(page.goto_urls.size).to eq(2)
          expect(crawl_results.results.map(&:external_id)).to eq(%w[n333 n334])
        end
      end
    end

    context "出品者 ID が取得できないセルだけがある場合" do
      let(:page_html) do
        search_list(
          <<~HTML
            <li>
              <div>
                <div>
                  <a href="https://auctions.yahoo.co.jp/jp/auction/n444">
                    <img src="https://example.com/thumb/n444.jpg" alt="">
                  </a>
                </div>
                <div class="lg:grid-tc_1fr_160px">
                  <a class="wb_break-all" href="https://auctions.yahoo.co.jp/jp/auction/n444">不正 seller</a>
                  <span>現在5,000円</span>
                  <span>（11/03 12:00終了予定）</span>
                  <a href="https://auctions.yahoo.co.jp/seller/">出品者</a>
                </div>
              </div>
            </li>
          HTML
        )
      end

      it "CrawlResults の検証エラーを含む StandardError を raise する" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          expect { crawler.execute }.to raise_error(StandardError, /CrawlResult 1:/)
        end
      end
    end
  end
end
