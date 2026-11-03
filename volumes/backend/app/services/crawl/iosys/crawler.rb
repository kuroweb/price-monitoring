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

      def call
        page_count = 1
        loop do
          break if page_count > MAX_PAGE
          break unless fetch_page(page_count)

          page_count += 1
        end

        raise StandardError, crawl_results.errors unless crawl_results.valid?

        crawl_results
      end

      private

      attr_reader :product

      def fetch_page(page_count)
        page_results = []
        has_next = false

        Retryable.retryable(tries: RETRY_COUNT) do
          Crawl::Client.execute do |page|
            page_results, has_next = read_page(page, page_count)
          end
        end

        page_results.each { |result| crawl_results.add(result) }
        has_next
      end

      def read_page(page, page_count)
        Rails.logger.info("Execute iosys crawl process. product_id: #{product.id} page: #{page_count}")

        response = page.goto(url(page_count), waitUntil: "domcontentloaded")
        load(page)
        ensure_results_page!(page, response)
        return [[], false] if no_results?(page)

        [build_results(page), exists_next_page?(page)]
      end

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

      def ensure_results_page!(page, response)
        status = response&.status
        raise StandardError, "Iosys search page returned HTTP #{status}" if status && status >= 400
        return if page.query_selector("#empty")
        return if item_doms(page).present?

        raise StandardError, "Iosys search page has neither #empty nor item results"
      end

      def no_results?(page)
        page.query_selector("#empty")&.inner_text.present?
      end

      def exists_next_page?(page)
        page.query_selector(".page-link[rel='next']").present?
      end

      def build_results(page)
        item_doms(page).map do |dom|
          CrawlResult.new(
            external_id: external_id(dom),
            name: name(dom),
            price: price(dom),
            thumbnail_url: thumbnail_url(dom)
          )
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
        href = dom.query_selector(".photo > picture > source").get_attribute("data-srcset")

        case href
        when "/common_img/dummy/dummy.gif", "/photos/no_photo_S.jpg", "/photos/no_photo_S.webp"
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
