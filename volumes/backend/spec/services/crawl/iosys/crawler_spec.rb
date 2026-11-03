require "rails_helper"

RSpec.describe Crawl::Iosys::Crawler, type: :service do
  describe "#call" do
    let(:iosys_crawl_setting) { instance_double(IosysCrawlSetting) }
    let(:product) { instance_double(Product, id: 1, iosys_crawl_setting:) }
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::Iosys::UrlGenerator).to receive(:new) do |page:, **|
        instance_double(Crawl::Iosys::UrlGenerator, generate: "https://iosys.co.jp/items?page=#{page}")
      end
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    def item_html(external_id:, name:, price:, thumbnail:)
      <<~HTML
        <li class="item">
          <a href="/items/#{external_id}">
            <div class="photo">
              <picture>
                <source data-srcset="#{thumbnail}">
              </picture>
            </div>
            <p class="name">#{name}</p>
            <p class="price">#{price}</p>
          </a>
        </li>
      HTML
    end

    context "検索結果がある場合" do
      let(:page_html) do
        <<~HTML
          <div id="empty"></div>
          <ul>
            #{item_html(
              external_id: "smartphone/iphone/simfree/iphone15_a3089/286191",
              name: "iPhone 15 128GB",
              price: "89,800円\n(税込)",
              thumbnail: "https://d27ea4kkb8flj9.cloudfront.net/286191_1_S.webp"
            )}
          </ul>
        HTML
      end

      it "商品情報を返し、DOM 読み込み完了では待たないこと" do
        crawl_results = crawler.call

        expect(crawl_results.results.size).to eq(1)
        expect(crawl_results.results.first).to have_attributes(
          external_id: "smartphone/iphone/simfree/iphone15_a3089/286191",
          name: "iPhone 15 128GB",
          price: 89_800,
          thumbnail_url: "https://d27ea4kkb8flj9.cloudfront.net/286191_1_S.webp"
        )
        expect(page.goto_urls).to eq(["https://iosys.co.jp/items?page=1"])
        expect(page.goto_options).to eq([{ waitUntil: "domcontentloaded" }])
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { '<div id="empty">該当する商品が見つかりませんでした</div>' }

      it "空の結果を返し例外にならないこと" do
        crawl_results = crawler.call

        expect(crawl_results.results).to be_empty
      end
    end

    context "空結果の要素が無く商品がある場合" do
      let(:page_html) do
        item_html(
          external_id: "smartphone/iphone/simfree/iphone15_a3089/286191",
          name: "iPhone 15 128GB",
          price: "89,800円",
          thumbnail: "https://d27ea4kkb8flj9.cloudfront.net/286191_1_S.webp"
        )
      end

      it "例外にせず商品を返すこと" do
        crawl_results = crawler.call

        expect(crawl_results.results.size).to eq(1)
      end
    end

    context "空結果の要素も商品も無い場合" do
      let(:page_html) { "<html><body></body></html>" }

      it "接続を引き直して再試行したあと例外になること" do
        expect { crawler.call }.to raise_error(
          StandardError,
          "Iosys search page has neither #empty nor item results"
        )
        expect(page.goto_urls.size).to eq(described_class::RETRY_COUNT)
        expect(Crawl::Client).to have_received(:execute).exactly(described_class::RETRY_COUNT).times
      end
    end

    context "プロキシが検索ページを拒否する場合" do
      let(:page_html) { "<html><body><h1>403 Forbidden</h1></body></html>" }

      before { page.response_status = 403 }

      it "接続を引き直して再試行したあと例外になること" do
        expect { crawler.call }.to raise_error(
          StandardError,
          "Iosys search page returned HTTP 403"
        )
        expect(Crawl::Client).to have_received(:execute).exactly(described_class::RETRY_COUNT).times
      end
    end

    context "拒否された接続の次で検索結果がある場合" do
      let(:forbidden_page) { CrawlFakePlaywrightPage.new("<html><body><h1>403 Forbidden</h1></body></html>") }
      let(:page_html) do
        item_html(
          external_id: "smartphone/iphone/simfree/iphone15_a3089/286191",
          name: "iPhone 15 128GB",
          price: "89,800円",
          thumbnail: "https://d27ea4kkb8flj9.cloudfront.net/286191_1_S.webp"
        )
      end

      before do
        forbidden_page.response_status = 403
        pages = [forbidden_page, page]
        allow(Crawl::Client).to receive(:execute).and_invoke(
          ->(&block) { block.call(pages.shift) },
          ->(&block) { block.call(pages.shift) }
        )
      end

      it "別の接続で商品を返すこと" do
        crawl_results = crawler.call

        expect(crawl_results.results.size).to eq(1)
        expect(crawl_results.results.first.external_id).to eq(
          "smartphone/iphone/simfree/iphone15_a3089/286191"
        )
      end
    end
  end
end
