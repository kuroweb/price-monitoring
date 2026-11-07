require "rails_helper"

RSpec.describe Crawl::Mercari::SyncProduct::Crawler, type: :service do
  describe "#call" do
    let(:mercari_product) do
      instance_double(
        MercariProduct,
        external_id: "m47633186566",
        name: "Mac Studio M1 Max",
        price: 210_000,
        thumbnail_url: "https://static.mercdn.net/thumb/item/webp/m47633186566_1.jpg",
        published: true,
        bought_date: Time.zone.local(2026, 9, 6)
      )
    end
    let(:page) { CrawlFakePlaywrightPage.new(page_html) }
    let(:crawler) { described_class.new(mercari_product:) }

    before do
      allow(Crawl::Client).to receive(:execute).and_yield(page)
      allow(crawler).to receive(:sleep)
    end

    context "出品中の商品ページの場合" do
      let(:page_html) do
        <<~HTML
          <div data-testid="name">Mac Studio M1 Max 32GB</div>
          <div data-testid="price"><span>¥</span><span>210,000</span></div>
          <img src="https://static.mercdn.net/item/detail/orig/photos/m47633186566_1.jpg">
        HTML
      end

      it "ページ内容で CrawlResult を返す" do
        result = crawler.call

        expect(result).to have_attributes(
          external_id: "m47633186566",
          name: "Mac Studio M1 Max 32GB",
          price: 210_000,
          thumbnail_url: "https://static.mercdn.net/item/detail/orig/photos/m47633186566_1.jpg",
          published: true,
          deleted: false
        )
      end
    end

    context "該当する商品は削除されています、と表示される場合" do
      let(:page_html) do
        <<~HTML
          <p>該当する商品は削除されています。</p>
          <img src="https://assets.eisa.mercari.com/ad.jpg">
        HTML
      end

      it "保存済みの値で deleted=true を返す" do
        result = crawler.call

        expect(result).to have_attributes(
          external_id: "m47633186566",
          name: "Mac Studio M1 Max",
          price: 210_000,
          thumbnail_url: "https://static.mercdn.net/thumb/item/webp/m47633186566_1.jpg",
          published: true,
          deleted: true
        )
      end
    end

    context "ページが見つかりませんでした、と表示される場合" do
      let(:page_html) { "<p>ページが見つかりませんでした</p>" }

      it "deleted=true を返す" do
        result = crawler.call

        expect(result.deleted).to be(true)
      end
    end
  end
end
