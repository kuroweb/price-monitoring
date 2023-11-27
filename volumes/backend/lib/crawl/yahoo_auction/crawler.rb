module Crawl
  module YahooAuction
    class Crawler
      def initialize(product:)
        @product = product
      end

      def execute
        Crawl::Client.execute do |browser|
          page = browser.new_page

          start = 1
          loop do
            page.goto(url(start))

            product_doms = page.query_selector_all("li.Product")
            product_doms.each { |p| yahoo_auction_products.push(parse_product(p)) }

            break unless exists_next_page?(page)
            break if loop_safe(start)

            start += 100
          end
        end

        yahoo_auction_products
      end

      private

      attr_reader :product

      def url(start)
        Crawl::YahooAuction::UrlGenerator.new(product:, start:).generate
      end

      def exists_next_page?(page)
        page.query_selector(".Pager__list.Pager__list--next > a.Pager__link")
      end

      def loop_safe(start)
        start > 100_000
      end

      def parse_product(dom)
        {
          product_id: product.id,
          yahoo_auction_id: yahoo_auction_id(dom),
          name: name(dom),
          price: price(dom),
          thumbnail_url: thumbnail_url(dom),
          published: true
        }
      end

      def yahoo_auction_id(dom)
        dom.query_selector(".Product__titleLink").get_attribute("data-auction-id")
      end

      def name(dom)
        dom.query_selector(".Product__titleLink").inner_text
      end

      def price(dom)
        dom.query_selector(".Product__priceValue").inner_text.gsub(/,|円/, "")
      end

      def thumbnail_url(dom)
        dom.eval_on_selector(".Product__imageData", "el => el.src")
      end

      def yahoo_auction_products
        @yahoo_auction_products ||= []
      end
    end
  end
end
