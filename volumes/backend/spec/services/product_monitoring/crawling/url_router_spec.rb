require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::UrlRouter do
  let(:crawling) { ProductMonitoring::Crawling }

  def route(url)
    described_class.call(product_crawl_setting: build(:product_crawl_setting, search_urls: [url])).keys.first
  end

  describe ".call" do
    def urls_by_site(keyword: nil, platforms: [], search_urls: [])
      described_class.call(product_crawl_setting: build(:product_crawl_setting, keyword:, platforms:, search_urls:))
    end

    it "検索語をサイトごとの検索URLにし、ヤフオクは出品中と落札相場の両方を作ること" do
      expect(urls_by_site(keyword: "iPad Pro &", platforms: %w[yahoo_auction yahoo_fleamarket janpara])).to eq(
        crawling::YahooAuction => ["https://auctions.yahoo.co.jp/search/search?p=iPad+Pro+%26",
                                   "https://auctions.yahoo.co.jp/closedsearch/closedsearch?p=iPad+Pro+%26"],
        crawling::YahooFleamarket => ["https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro%20%26"],
        crawling::Janpara => ["https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro+%26"]
      )
    end

    it "検索語から作ったURLのあとに、そのサイトの検索結果URLを並べること" do
      expect(urls_by_site(keyword: "phone", platforms: ["iosys"],
                          search_urls: ["https://iosys.co.jp/items?q=x", "https://jp.mercari.com/search?keyword=x"]))
        .to eq(crawling::Iosys => ["https://iosys.co.jp/items?q=phone", "https://iosys.co.jp/items?q=x"],
               crawling::Mercari => ["https://jp.mercari.com/search?keyword=x"])
    end

    it "対応する検索ページを、そのサイトの一覧に振り分けること" do
      expect(route("https://jp.mercari.com/search?keyword=phone")).to eq(crawling::Mercari)
      expect(route("https://iosys.co.jp/items?q=phone")).to eq(crawling::Iosys)
      expect(route("https://www.janpara.co.jp/sale/search/result/?KEYWORDS=iPad+Pro"))
        .to eq(crawling::Janpara)
      expect(route("https://ec.treasure-f.com/search?word=x")).to eq(crawling::TreasureFactory)
    end

    it "出品中と落札相場の両方のオークション検索を振り分け、クエリのない検索は拒否すること" do
      %w[search/search closedsearch/closedsearch].each do |path|
        expect(route("https://auctions.yahoo.co.jp/#{path}?p=ipad")).to eq(crawling::YahooAuction)
        expect { route("https://auctions.yahoo.co.jp/#{path}") }.to raise_error(ArgumentError)
      end
    end

    it "クエリのない Yahoo!フリマの検索パスを受け入れ、不正なパスを拒否すること" do
      expect(route("https://paypayfleamarket.yahoo.co.jp/search/iPad%20Pro"))
        .to eq(crawling::YahooFleamarket)
      ["/search/", "/search/a/b", "/search/a%2Fb"].each do |path|
        expect do
          route("https://paypayfleamarket.yahoo.co.jp#{path}")
        end.to raise_error(ArgumentError)
      end
    end

    it "検索語のない検索を拒否すること" do
      ["https://jp.mercari.com/search", "https://iosys.co.jp/items", "https://ec.treasure-f.com/search",
       "https://www.janpara.co.jp/sale/search/result/?KEYWORDS=+",
       "https://www.janpara.co.jp/sale/search/result/"].each do |url|
        expect { route(url) }.to raise_error(ArgumentError)
      end
    end

    it "エンコード済みや重複パラメータを含む iosys のグループ検索を拒否すること" do
      ["t=g", "q=phone&%74=%67", "t=x&t=g"].each do |query|
        expect { route("https://iosys.co.jp/items?#{query}") }
          .to raise_error(ArgumentError, /個別出品.*t=gなし/)
      end
    end

    ["http://jp.mercari.com/search?q=x", "https://jp.mercari.com.evil/search?q=x",
     "https://user@jp.mercari.com/search?q=x", "https://jp.mercari.com:444/search?q=x",
     "https://jp.mercari.com/item/abc", "https://127.0.0.1/search?q=x",
     "https://janpara.co.jp/sale/search/result/?KEYWORDS=x",
     "https://www.janpara.co.jp/sale/search/detail/?KEYWORDS=x",
     "https://ec.treasure-f.com/item/1?x=1"].each do |url|
      it "対応しない URL #{url} を拒否すること" do
        expect { route(url) }.to raise_error(ArgumentError)
      end
    end
  end
end
