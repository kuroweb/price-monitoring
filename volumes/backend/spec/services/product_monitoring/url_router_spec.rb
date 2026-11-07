require "rails_helper"

RSpec.describe ProductMonitoring::UrlRouter do
  it "routes both auction searches without scheduling detail checks" do
    %w[search/search closedsearch/closedsearch].each do |path|
      expect(described_class.call(url: "https://auctions.yahoo.co.jp/#{path}?p=ipad"))
        .to include(platform: "yahoo_auction", site: ProductMonitoring::Sites::YahooAuction)
      expect { described_class.call(url: "https://auctions.yahoo.co.jp/#{path}") }.to raise_error(ArgumentError)
    end
    expect(described_class.detail_site("yahoo_auction")).to be_nil
  end

  it "accepts Yahoo search paths without a query and rejects invalid paths" do
    url = "https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro"
    expect(described_class.call(url: url)).to include(platform: "yahoo_fleamarket")
    ["/search/", "/search/a/b", "/search/a%2Fb"].each do |path|
      expect { described_class.call(url: "https://paypayfleamarket.yahoo.co.jp#{path}") }.to raise_error(ArgumentError)
    end
    ["https://jp.mercari.com/search", "https://iosys.co.jp/items"].each do |missing_query|
      expect { described_class.call(url: missing_query) }.to raise_error(ArgumentError)
    end
  end

  describe ".call" do
    it "routes supported search pages" do
      expect(described_class.call(url: "https://jp.mercari.com/search?keyword=phone")).to eq(
        platform: "mercari", canonical_url: "https://jp.mercari.com/search?keyword=phone", site: ProductMonitoring::Sites::Mercari
      )
      expect(described_class.call(url: "https://iosys.co.jp/items?q=phone")).to eq(
        platform: "iosys", canonical_url: "https://iosys.co.jp/items?q=phone", site: ProductMonitoring::Sites::Iosys
      )
    end

    it "rejects iosys group searches, including encoded and repeated parameters" do
      ["t=g", "q=phone&%74=%67", "t=x&t=g"].each do |query|
        expect { described_class.call(url: "https://iosys.co.jp/items?#{query}") }
          .to raise_error(ArgumentError, /個別出品.*t=gなし/)
      end
    end

    ["http://jp.mercari.com/search?q=x", "https://jp.mercari.com.evil/search?q=x",
     "https://user@jp.mercari.com/search?q=x", "https://jp.mercari.com:444/search?q=x",
     "https://jp.mercari.com/item/abc", "https://127.0.0.1/search?q=x"].each do |url|
      it "rejects unsafe URL #{url}" do
        expect { described_class.call(url: url) }.to raise_error(ArgumentError)
      end
    end
  end
end
