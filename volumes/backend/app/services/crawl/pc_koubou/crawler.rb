module Crawl
  module PcKoubou
    class Crawler
      RETRY_COUNT = 5
      MAX_PAGE = 5

      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        Crawl::Client.execute do |page|
          Retryable.retryable(tries: RETRY_COUNT) do
            page.goto(url)
            load(page)

            return crawl_results if no_results?(page)

            append_results(page)
          end
        end

        raise StandardError, crawl_results.errors unless crawl_results.valid?

        crawl_results
      end

      private

      attr_reader :product

      def url
        UrlGenerator.new(pc_koubou_crawl_setting:).generate
      end

      def load(page, retry_count = RETRY_COUNT)
        return if retry_count.zero?

        sleep(1)
        more_button = page.query_selector(".more >> a")

        if more_button&.visible?
          more_button.click
          load(page)
        else
          load(page, retry_count - 1)
        end
      end

      def no_results?(page)
        page.query_selector(".itemlist__none").present?
      end

      def append_results(page)
        doms = page.query_selector_all(".search-result")

        doms.each do |dom|
          result = CrawlResult.new(
            external_id: external_id(dom),
            name: name(dom),
            price: price(dom),
            thumbnail_url: thumbnail_url(dom)
          )
          crawl_results.add(result)
        end
      end

      def item_doms(page)
        page.query_selector_all(".search-result")
      end

      def external_id(dom)
        href = dom.query_selector("a").get_attribute("href")
        href.match(/product_id=(.*)/)[1]
      end

      def name(dom)
        dom.query_selector(".name").inner_text
      end

      def price(dom)
        dom.query_selector(".price--num").inner_text.gsub(/,/, "").to_i
      end

      def thumbnail_url(dom)
        path = dom.query_selector("img").get_attribute("src")
        "https://www.pc-koubou.jp#{path}"
      end

      def pc_koubou_crawl_setting
        @pc_koubou_crawl_setting ||= product.pc_koubou_crawl_setting
      end

      def crawl_results
        @crawl_results ||= CrawlResults.new
      end
    end
  end
end
