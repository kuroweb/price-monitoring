module Crawl
  module UsedSofmap
    class Crawler
      RETRY_COUNT = 5
      MAX_PAGE = 5

      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        Crawl::Client.execute do |page|
          page_count = 1
          loop do
            break if page_count > MAX_PAGE

            Retryable.retryable(tries: RETRY_COUNT) do
              Rails.logger.info("Execute used_sofmap crawl process. product_id: #{product.id} page: #{page_count}")

              page.goto(url(page_count))

              load(page)

              break if no_results?(page)

              append_results(page)
            end

            break unless exists_next_page?(page)

            page_count += 1
          end
        end

        raise StandardError, crawl_results.errors unless crawl_results.valid?

        crawl_results
      end

      private

      attr_reader :product

      def url(page)
        UrlGenerator.new(used_sofmap_crawl_setting:, page:).generate
      end

      def load(page)
        sleep(2)
        30.times do
          page.mouse.wheel(0, 200)
          sleep(0.005)
        end
      end

      def no_results?(page)
        page.query_selector(".no-item-area").get_attribute("style") != "display: none;"
      end

      def exists_next_page?(page)
        page.query_selector("span.next").present?
      end

      def append_results(page)
        doms = item_doms(page)

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
        page.query_selector_all(".sys-aggregation-item")
      end

      def external_id(dom)
        dom.get_attribute("href")
      end

      def name(dom)
        dom.query_selector(".sys-short-name").inner_text
      end

      def price(dom)
        dom.query_selector(".sys-price").inner_text.gsub(/,/, "").to_i
      end

      def thumbnail_url(dom)
        dom.query_selector(".sys-image").get_attribute("src")
      end

      def used_sofmap_crawl_setting
        @used_sofmap_crawl_setting ||= product.used_sofmap_crawl_setting
      end

      def crawl_results
        @crawl_results ||= CrawlResults.new
      end
    end
  end
end
