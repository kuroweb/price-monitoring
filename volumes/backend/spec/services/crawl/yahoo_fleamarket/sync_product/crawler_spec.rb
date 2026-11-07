require "rails_helper"

RSpec.describe Crawl::YahooFleamarket::SyncProduct::Crawler, type: :service do
  describe "#call" do
    let(:yahoo_fleamarket_product) do
      instance_double(
        YahooFleamarketProduct,
        external_id: "z100",
        seller_id: "p111",
        name: "stored name",
        price: 1,
        thumbnail_url: "https://example.com/old.jpg",
        published: true,
        bought_date: nil
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(yahoo_fleamarket_product:) }

    before do
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    context "出品中の商品ページの場合" do
      let(:page_html) do
        <<~HTML
          <a href="https://paypayfleamarket.yahoo.co.jp/user/p222">seller</a>
          <div class="ItemTitle__Component">iPad Pro 11</div>
          <div class="ItemPrice__Component">12,800円</div>
          <div class="ItemMain__Component"><img src="https://example.com/item.jpg"></div>
        HTML
      end

      it "ページ内容で CrawlResult を返す" do
        result = crawler.call

        expect(result).to have_attributes(
          external_id: "z100",
          seller_id: "p222",
          name: "iPad Pro 11",
          price: 12_800,
          thumbnail_url: "https://example.com/item.jpg",
          published: true,
          deleted: false
        )
      end
    end

    context "売り切れ画像がある場合" do
      let(:page_html) do
        <<~HTML
          <a href="https://paypayfleamarket.yahoo.co.jp/user/p222">seller</a>
          <div class="ItemTitle__Component">sold item</div>
          <div class="ItemPrice__Component">9,000円</div>
          <div class="ItemMain__Component"><img src="https://example.com/item.jpg"></div>
          <img alt="sold">
        HTML
      end

      it "published=false を返す" do
        result = crawler.call

        expect(result.published).to be(false)
      end
    end

    context "商品が存在しない場合" do
      let(:page_html) { "<span>この商品は存在しません</span>" }

      it "deleted=true を返す" do
        result = crawler.call

        expect(result).to have_attributes(deleted: true, external_id: "z100")
      end
    end
  end
end
