module Crawl
  module YahooAuction
    class Syncer
      def initialize(yahoo_auction_product:)
        @yahoo_auction_product = yahoo_auction_product
      end

      def execute
        Crawl::Client.execute do |browser|
          page = browser.new_page
          page.goto(url(yahoo_auction_product.yahoo_auction_id))

          parse_product(page)
        end
      end

      private

      attr_reader :yahoo_auction_product

      def url(yahoo_auction_id)
        "https://page.auctions.yahoo.co.jp/jp/auction/#{yahoo_auction_id}"
      end

      def parse_product(dom)
        {
          id: yahoo_auction_product.id,
          product_id: yahoo_auction_product.product_id,
          yahoo_auction_id: yahoo_auction_product.yahoo_auction_id,
          name: name(dom),
          price: price(dom),
          thumbnail_url: thumbnail_url(dom),
          published: published?(dom)
        }
      end

      def name(dom)
        dom.query_selector(".ProductTitle__text").inner_text
      end

      def price(dom)
        dom.query_selector(".Price__value").inner_text.gsub(/,|円（税 \d+ 円）/, "")
      end

      def thumbnail_url(dom)
        dom.eval_on_selector(".ProductImage__inner > img", "el => el.src")
      end

      def published?(dom)
        !dom.query_selector(".ClosedHeader")
      end
    end
  end
end
