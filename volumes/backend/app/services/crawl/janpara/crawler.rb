module Crawl
  module Janpara
    class Crawler
      RETRY_COUNT = 5
      MAX_PAGE = 5

      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        Crawl::Client.execute do |page|
          page_count = 1
          loop do
            break if page_count > MAX_PAGE

            Retryable.retryable(tries: RETRY_COUNT) do
              Rails.logger.info("Execute janpara crawl process. product_id: #{product.id} page: #{page_count}")

              page.goto(url(page_count))

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
        UrlGenerator.new(janpara_crawl_setting:, page:).generate
      end

      def no_results?(page)
        page.query_selector(".sorry").present?
      end

      def exists_next_page?(page)
        page.query_selector(".pageLink[title='次ページ']").present?
      end

      def append_results(page)
        doms = item_doms(page).select { |dom| published(dom) }

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
        page.query_selector_all(".search_item_s")
      end

      def external_id(dom)
        href = dom.query_selector(".search_itemlink").get_attribute("href")
        href.match(/(SRCODE=\d+|ITMCODE=\d+)/).to_s
      end

      def name(dom)
        dom.query_selector(".search_itemname").inner_text.gsub(/\R/, "")
      end

      def price(dom)
        amount_doms = dom.query_selector_all(".item_amount")
        case amount_doms.size
        when 1
          amount_doms[0].inner_text.gsub(/(¥|,|～)/, "").to_i
        when 2
          amount_doms[1].inner_text.gsub(/(¥|,|～)/, "").to_i
        end
      end

      def thumbnail_url(dom)
        src = dom.query_selector("img").get_attribute("src")

        url?(src) ? src : "https://www.janpara.co.jp#{src}"
      end

      def url?(string)
        !!(string =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/)
      end

      def published(dom)
        dom.query_selector(".item_amount").present?
      end

      def janpara_crawl_setting
        @janpara_crawl_setting ||= product.janpara_crawl_setting
      end

      def crawl_results
        @crawl_results ||= CrawlResults.new
      end
    end
  end
end
