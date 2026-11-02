require "rails_helper"

RSpec.describe Crawl::YahooFleamarket::SyncProducts::Unpublished::Crawler, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  describe "#execute" do
    let(:yahoo_auction_crawl_setting) { instance_double(YahooAuctionCrawlSetting) }
    let(:product) { instance_double(Product, id: 1, yahoo_auction_crawl_setting:) }
    let(:url_generator) do
      instance_double(
        Crawl::YahooFleamarket::SyncProducts::Unpublished::UrlGenerator,
        generate: "https://auctions.yahoo.co.jp/closedsearch/closedsearch?b=1"
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::YahooFleamarket::SyncProducts::Unpublished::UrlGenerator).to receive(:new).and_return(url_generator)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    def sold_item_row(external_id:, name:, price:, end_label:, seller_id: "p111")
      <<~HTML
        <li>
          <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/#{external_id}">
            <img src="https://example.com/#{external_id}.jpg" alt="#{name}">
          </a>
          <a href="https://paypayfleamarket.yahoo.co.jp/user/#{seller_id}">seller</a>
          <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/#{external_id}">#{name}</a>
          <span>落札#{price}円</span>
          <span>#{end_label}終了</span>
        </li>
      HTML
    end

    context "落札済み商品が並ぶ場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            #{sold_item_row(
              external_id: 'z555',
              name: 'iPad Pro 512GB',
              price: '42,300',
              end_label: '11/3 00:12'
            )}
          </ul>
        HTML
      end

      it "published=false と落札日時を返すこと" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results.size).to eq(1)
          expect(crawl_results.results[0]).to have_attributes(
            external_id: "z555",
            seller_id: "p111",
            name: "iPad Pro 512GB",
            price: 42_300,
            thumbnail_url: "https://example.com/z555.jpg",
            published: false
          )
          expect(crawl_results.results[0].bought_date).to eq(Time.zone.local(2026, 11, 3, 0, 12, 0))
        end
      end
    end

    context "年またぎで終了日時が未来に見える場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            #{sold_item_row(
              external_id: 'z556',
              name: 'Year boundary item',
              price: '1,000',
              end_label: '12/31 23:00'
            )}
          </ul>
        HTML
      end

      it "bought_date を 1 年戻した日時にすること" do
        travel_to Time.zone.local(2027, 1, 2, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results[0].bought_date).to eq(Time.zone.local(2026, 12, 31, 23, 0, 0))
        end
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { '<div class="Notice__wandQuery">見つかりませんでした</div>' }

      it "空の結果を返し例外にならないこと" do
        crawl_results = crawler.execute

        expect(crawl_results.results).to be_empty
      end
    end

    context "2 ページ目へのリンクがある場合" do
      let(:page_html) do
        <<~HTML
          <ul>#{sold_item_row(external_id: 'z111', name: 'page1', price: '1,000', end_label: '11/1 10:00')}</ul>
          <a href="https://auctions.yahoo.co.jp/closedsearch/closedsearch?b=101&amp;n=100">次へ</a>
        HTML
      end
      let(:page2_html) do
        <<~HTML
          <ul>#{sold_item_row(external_id: 'z222', name: 'page2', price: '2,000', end_label: '11/2 11:00')}</ul>
        HTML
      end
      let(:page) do
        pages = [page_html, page2_html]
        Class.new(CrawlFakePlaywrightPage) do
          define_method(:initialize) do |pages|
            @pages = pages
            @page_index = 0
            super(@pages[@page_index])
          end

          define_method(:goto) do |url|
            @goto_urls << url
            @doc = Nokogiri::HTML(@pages[@goto_urls.size - 1])
          end
        end.new(pages)
      end

      before do
        allow(Crawl::YahooFleamarket::SyncProducts::Unpublished::UrlGenerator).to receive(:new).and_return(
          instance_double(Crawl::YahooFleamarket::SyncProducts::Unpublished::UrlGenerator, generate: "page1"),
          instance_double(Crawl::YahooFleamarket::SyncProducts::Unpublished::UrlGenerator, generate: "page2")
        )
      end

      it "2 ページ分を取得すること" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          crawl_results = crawler.execute

          expect(crawl_results.results.map(&:external_id)).to eq(%w[z111 z222])
          expect(page.goto_urls).to eq(%w[page1 page2])
        end
      end
    end

    context "seller リンクがない行がある場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            <li>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z999">
                <img src="https://example.com/z999.jpg" alt="不正行">
              </a>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z999">不正行</a>
              <span>落札100円</span>
              <span>11/3 00:00終了</span>
            </li>
          </ul>
        HTML
      end

      it "CrawlResults の検証エラーを含む StandardError を raise すること" do
        travel_to Time.zone.local(2026, 11, 3, 12, 0, 0) do
          expect { crawler.execute }.to raise_error(StandardError, /CrawlResult 1:.*Seller/)
        end
      end
    end

    context "落札日時ラベルがない行がある場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            <li>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z888">
                <img src="https://example.com/z888.jpg" alt="日付なし">
              </a>
              <a href="https://paypayfleamarket.yahoo.co.jp/user/p888">seller</a>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z888">日付なし</a>
              <span>落札500円</span>
            </li>
          </ul>
        HTML
      end

      it "bought_date 欠落で StandardError を raise すること" do
        expect { crawler.execute }.to raise_error(StandardError, /CrawlResult 1:.*Bought date/)
      end
    end

    context "旧 li.Product セレクタの markup の場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            <li class="Product">
              <div class="Product__image"><img src="https://example.com/old.jpg"></div>
              <div class="Product__detail">
                <span class="Product__price">1000円</span>
              </div>
            </li>
          </ul>
        HTML
      end

      before do
        allow(Retryable).to receive(:retryable).and_yield
      end

      it "ListStructureChanged を raise すること" do
        expect { crawler.execute }.to raise_error(Crawl::YahooFleamarket::ListStructureChanged)
      end
    end
  end
end
