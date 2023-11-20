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
        dom = page.query_selector(".Pager__list.Pager__list--next > a.Pager__link")
        !dom.nil?
      end

      def loop_safe(start)
        start > 100_000
      end

      def parse_product(dom)
        {
          yahoo_auction_id: dom.query_selector(".Product__titleLink").get_attribute("data-auction-id"),
          name: dom.query_selector(".Product__titleLink").inner_text,
          price: dom.query_selector(".Product__priceValue").inner_text.gsub(/,|円/, ""),
          thumbnail_url: dom.eval_on_selector(".Product__imageData", "el => el.src"),
          published: true
        }
      end

      def yahoo_auction_products
        @yahoo_auction_products ||= []
      end
    end
  end
end
