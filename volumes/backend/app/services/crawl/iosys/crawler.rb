module Crawl
  module Iosys
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
              Rails.logger.info("Execute iosys crawl process. product_id: #{product.id} page: #{page_count}")

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
        UrlGenerator.new(iosys_crawl_setting:, page:).generate
      end

      def load(page)
        sleep(2)
        30.times do
          page.mouse.wheel(0, 200)
          sleep(0.005)
        end
      end

      def no_results?(page)
        page.query_selector(".empty").inner_text.present?
      end

      def exists_next_page?(page)
        page.query_selector(".page-link[rel='next']").present?
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
        page.query_selector_all("li.item")
      end

      def external_id(dom)
        href = dom.query_selector("a").get_attribute("href")
        href.match(%r{/items/(.*)})[1]
      end

      def name(dom)
        dom.query_selector(".name").inner_text
      end

      def price(dom)
        dom.query_selector(".price").inner_text.gsub(/(,|円|\R|\(税込\))/, "").to_i
      end

      def thumbnail_url(dom)
        href = dom.query_selector("img").get_attribute("src")

        case href
        when "/common_img/dummy/dummy.gif", "/photos/no_photo_S.jpg"
          "https://iosys.co.jp/photos/no_photo_L.webp"
        else
          href
        end
      end

      def iosys_crawl_setting
        @iosys_crawl_setting ||= product.iosys_crawl_setting
      end

      def crawl_results
        @crawl_results ||= CrawlResults.new
      end
    end
  end
end
