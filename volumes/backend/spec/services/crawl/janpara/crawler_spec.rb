require "rails_helper"

RSpec.describe Crawl::Janpara::Crawler, type: :service do
  describe "#call" do
    let(:janpara_crawl_setting) { instance_double(JanparaCrawlSetting) }
    let(:product) { instance_double(Product, id: 1, janpara_crawl_setting:) }
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(product:) }

    before do
      allow(Crawl::Janpara::UrlGenerator).to receive(:new) do |page:, **|
        instance_double(Crawl::Janpara::UrlGenerator, generate: "https://www.janpara.co.jp/search?PAGE=#{page}")
      end
      allow(Crawl::Client).to receive(:execute).and_yield(page)
    end

    context "検索結果がある場合" do
      let(:page_html) do
        <<~HTML
          <div class="search_item_s">
            <a class="search_itemlink" href="/sale/search/detail/?ITMCODE=153732"></a>
            <p class="search_itemname">Apple iPhone 15 128GB</p>
            <span class="item_amount">¥89,800</span>
            <img src="/images/items/153732a_s.jpg">
          </div>
        HTML
      end

      it "商品情報を返す" do
        crawl_results = crawler.call

        expect(crawl_results.results.first).to have_attributes(
          external_id: "ITMCODE=153732",
          name: "Apple iPhone 15 128GB",
          price: 89_800,
          thumbnail_url: "https://www.janpara.co.jp/images/items/153732a_s.jpg"
        )
      end

      it "WAF に拒否されないよう、じゃんぱら用の User-Agent で接続する" do
        crawler.call

        expect(Crawl::Client).to have_received(:execute)
          .with(user_agent: Crawl::RequestBlocklist::JANPARA_USER_AGENT)
      end
    end

    context "検索結果が 0 件の場合" do
      let(:page_html) { '<div class="sorry">該当する商品がありません</div>' }

      it "空の結果を返し例外にならない" do
        expect(crawler.call.results).to be_empty
      end
    end
  end
end
