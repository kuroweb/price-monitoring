module Crawl
  module YahooAuction
    class CrawlService
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        return if crawl_setting.disabled?

        Crawl::Client.execute do |browser|
          page = browser.new_page
          page.goto("https://auctions.yahoo.co.jp/search/search?auccat=&tab_ex=commerce&ei=utf-8&aq=-1&oq=&sc_i=&fr=auc_top&p=m2+macbook+air&x=0&y=0")
          page.eval_on_selector("a[data-auction-id=m1112815697]", "el => el.href")
        end
      end

      private :product

      def crawl_setting
        @crawl_setting ||= product.crawl_setting.yahoo_auction_crawl_setting
      end
    end
  end
end
