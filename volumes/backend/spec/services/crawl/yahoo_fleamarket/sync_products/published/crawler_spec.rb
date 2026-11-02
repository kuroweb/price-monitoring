require "rails_helper"

RSpec.describe Crawl::YahooFleamarket::SyncProducts::Published::Crawler, type: :service do
  describe "#execute" do
    let(:yahoo_auction_crawl_setting) { instance_double(YahooAuctionCrawlSetting) }
    let(:product) { instance_double(Product, id: 1, yahoo_auction_crawl_setting:) }
    let(:url_generator) do
      instance_double(
        Crawl::YahooFleamarket::SyncProducts::Published::UrlGenerator,
        generate: "https://auctions.yahoo.co.jp/search/search?b=1"
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::YahooFleamarket::SyncProducts::Published::UrlGenerator).to receive(:new).and_return(url_generator)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    def item_row(external_id:, name:, price:, seller_id: "p111")
      <<~HTML
        <li>
          <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/#{external_id}">
            <img src="https://example.com/#{external_id}.jpg" alt="#{name}">
          </a>
          <a href="https://paypayfleamarket.yahoo.co.jp/user/#{seller_id}">seller</a>
          <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/#{external_id}">#{name}</a>
          <span>即決#{price}円</span>
        </li>
      HTML
    end

    context "PayPayフリマ商品とスケルトン・価格なし行が混在する場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            #{item_row(external_id: 'z111', name: 'Magic Keyboard', price: '15,980')}
            #{item_row(external_id: 'z222', name: 'iPad Pro 11', price: '50,000', seller_id: 'p222')}
            <li>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z333">
                <img src="https://example.com/z333.jpg" alt="">
              </a>
            </li>
            <li>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z444">広告のみ</a>
            </li>
          </ul>
        HTML
      end

      it "出品中商品だけが順序どおり返ること" do
        crawl_results = crawler.execute

        expect(crawl_results.results.size).to eq(2)
        expect(crawl_results.results[0]).to have_attributes(
          external_id: "z111",
          seller_id: "p111",
          name: "Magic Keyboard",
          price: 15_980,
          thumbnail_url: "https://example.com/z111.jpg",
          published: true,
          bought_date: nil
        )
        expect(crawl_results.results[1]).to have_attributes(
          external_id: "z222",
          seller_id: "p222",
          name: "iPad Pro 11",
          price: 50_000,
          published: true
        )
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
          <ul>#{item_row(external_id: 'z111', name: 'page1', price: '1,000')}</ul>
          <a href="https://auctions.yahoo.co.jp/search/search?b=101&amp;n=100">次へ</a>
        HTML
      end
      let(:page2_html) do
        <<~HTML
          <ul>#{item_row(external_id: 'z222', name: 'page2', price: '2,000')}</ul>
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
        allow(Crawl::YahooFleamarket::SyncProducts::Published::UrlGenerator).to receive(:new).and_return(
          instance_double(Crawl::YahooFleamarket::SyncProducts::Published::UrlGenerator, generate: "page1"),
          instance_double(Crawl::YahooFleamarket::SyncProducts::Published::UrlGenerator, generate: "page2")
        )
      end

      it "2 ページ分を取得すること" do
        crawl_results = crawler.execute

        expect(crawl_results.results.map(&:external_id)).to eq(%w[z111 z222])
        expect(page.goto_urls).to eq(%w[page1 page2])
      end
    end

    context "seller リンクがない行がある場合" do
      let(:page_html) do
        <<~HTML
          <ul>
            <li>
              <a target="_blank" href="https://paypayfleamarket.yahoo.co.jp/item/z999">不正行</a>
              <img src="https://example.com/z999.jpg" alt="">
              <span>即決100円</span>
            </li>
          </ul>
        HTML
      end

      it "CrawlResults の検証エラーを含む StandardError を raise すること" do
        expect { crawler.execute }.to raise_error(StandardError, /CrawlResult 1:/)
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
