require "rails_helper"

RSpec.describe Crawl::YahooFleamarket::SyncProducts::ListItem do
  describe ".next_page?" do
    let(:page) { CrawlFakePlaywrightPage.new(html) }

    context "href が ?b=101 のとき" do
      let(:html) { '<a href="https://auctions.yahoo.co.jp/search/search?b=101&amp;n=100">次へ</a>' }

      it "true を返すこと" do
        expect(described_class.next_page?(page, 1)).to be(true)
      end
    end

    context "href が b=1010 のとき" do
      let(:html) { '<a href="https://auctions.yahoo.co.jp/search/search?b=1010">次へ</a>' }

      it "false を返すこと" do
        expect(described_class.next_page?(page, 1)).to be(false)
      end
    end

    context "href が sb=101 のとき" do
      let(:html) { '<a href="https://auctions.yahoo.co.jp/search/search?sb=101">次へ</a>' }

      it "false を返すこと" do
        expect(described_class.next_page?(page, 1)).to be(false)
      end
    end
  end
end
