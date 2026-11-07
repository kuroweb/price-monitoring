require "rails_helper"

RSpec.describe Crawl::Mercari::SyncProducts::Crawler, type: :service do
  describe "#execute" do
    let(:mercari_crawl_setting) { instance_double(MercariCrawlSetting) }
    let(:product) { instance_double(Product, id: 1, mercari_crawl_setting:) }
    let(:url_generator) do
      instance_double(Crawl::Mercari::SyncProducts::UrlGenerator, generate: "https://jp.mercari.com/search?page=0")
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::Mercari::SyncProducts::UrlGenerator).to receive(:new).and_return(url_generator)
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    def published_item_cell(external_id:, name:, price:, sold_out: false)
      alt_suffix = sold_out ? " 売り切れ" : "のサムネイル"
      <<~HTML
        <li data-testid="item-cell">
          <div>
            <a href="/item/#{external_id}" data-testid="thumbnail-link">
              <span>
                <picture><img alt="#{name}#{alt_suffix}" loading="lazy"></picture>
                <span data-testid="item-tile-price"><span><span>¥</span><span>#{price}</span></span></span>
              </span>
              <p data-testid="thumbnail-item-name">#{name}</p>
            </a>
          </div>
        </li>
      HTML
    end

    def search_grid(cells_html)
      <<~HTML
        <div data-testid="search-item-grid">
          <ul>
            #{cells_html}
          </ul>
        </div>
      HTML
    end

    context "検索結果 grid に出品中・売り切れ・スケルトン・shop が混在する場合" do
      let(:page_html) do
        search_grid(<<~HTML)
          #{published_item_cell(external_id: 'm111', name: '美品 Magic Keyboard', price: '17,480')}
          #{published_item_cell(external_id: 'm222', name: 'XSONIC XTONE', price: '9,800', sold_out: true)}
          <li data-testid="item-cell"><div><span></span><div><div><span></span></div></div></div></li>
          <li data-testid="item-cell">
            <div>
              <a href="/shops/product/2JYzYsoFGLjNP2yAfRaeLR" data-testid="thumbnail-link">
                <p data-testid="thumbnail-item-name">shop item</p>
              </a>
            </div>
          </li>
        HTML
      end

      it "出品中と売り切れだけが順序どおり返ること" do
        crawl_results = crawler.execute

        expect(crawl_results.results.size).to eq(2)
        expect(crawl_results.results[0]).to have_attributes(
          external_id: "m111",
          name: "美品 Magic Keyboard",
          price: 17_480,
          thumbnail_url: "https://static.mercdn.net/thumb/item/webp/m111_1.jpg",
          published: true
        )
        expect(crawl_results.results[1]).to have_attributes(
          external_id: "m222",
          name: "XSONIC XTONE",
          price: 9_800,
          thumbnail_url: "https://static.mercdn.net/thumb/item/webp/m222_1.jpg",
          published: false
        )
      end

      it "1 ページ分だけ goto すること" do
        crawler.execute

        expect(page.goto_urls.size).to eq(1)
        expect(page.goto_urls.first).to eq("https://jp.mercari.com/search?page=0")
      end
    end

    describe "#open_page" do
      let(:page_html) do
        <<~HTML
          <div data-testid="search-item-grid">
            <ul><li data-testid="item-cell"><a href="/item/m111"></a></li></ul>
          </div>
          <div data-testid="pagination-next-button"></div>
        HTML
      end

      it "1 ページ目は URL を開くこと" do
        crawler.open_page(page, 0, retried: false)

        expect(page.goto_urls).to eq(["https://jp.mercari.com/search?page=0"])
        expect(page.clicks).to be_empty
      end

      it "2 ページ目以降は次へをクリックし、先頭商品が変わるまで待つこと" do
        crawler.open_page(page, 1, retried: false)

        expect(page.goto_urls).to be_empty
        expect(page.clicks).to eq(["pagination-next-button"])
        expect(page.wait_for_function_calls.first.last).to include(arg: "/item/m111")
      end

      it "リトライ時は URL を開き直すこと" do
        crawler.open_page(page, 2, retried: true)

        expect(page.goto_urls.size).to eq(1)
        expect(page.clicks).to be_empty
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { '<div class="merEmptyState">見つかりませんでした</div>' }

      it "空の結果を返し例外にならないこと" do
        crawl_results = crawler.execute

        expect(crawl_results.results).to be_empty
      end
    end

    context "a の href が item/ にマッチしないセルがある場合" do
      let(:page_html) do
        search_grid(
          <<~HTML
            <li data-testid="item-cell">
              <div>
                <a href="/other/m999" data-testid="thumbnail-link">
                  <span data-testid="item-tile-price"><span>¥100</span></span>
                  <p data-testid="thumbnail-item-name">不正 href</p>
                </a>
              </div>
            </li>
          HTML
        )
      end

      it "CrawlResults の検証エラーを含む StandardError を raise すること" do
        expect { crawler.execute }.to raise_error(StandardError, /CrawlResult 1:/)
      end
    end
  end
end
