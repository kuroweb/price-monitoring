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

            break unless exists_next_page?(page)
            break if loop_safe(start)

            start += 100
          end
        end
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
    end
  end
end
