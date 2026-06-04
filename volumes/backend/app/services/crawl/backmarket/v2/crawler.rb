module Crawl
  module Backmarket
    module V2
      class Crawler
        RETRY_COUNT = 3
        REQUEST_COUNT = 10
        SLEEP_SECONDS = 5
        NAVIGATION_RETRY_COUNT = 3
        WAIT_TIMEOUT_MS = 15_000
        BACKMARKET_BASE_URL = "https://www.backmarket.co.jp".freeze
        PROXY_INVALIDATION_STATUS_CODES = [403, 429].freeze
        RETRYABLE_ERROR_MESSAGES = [
          "Target page, context or browser has been closed",
          "Execution context was destroyed"
        ].freeze

        def self.call(...)
          new(...).call
        end

        def initialize(backmarket_watch_target:)
          @backmarket_watch_target = backmarket_watch_target
        end

        def call
          Retryable.retryable(tries: RETRY_COUNT) do
            fallback_result = nil

            REQUEST_COUNT.times do
              sleep SLEEP_SECONDS

              result = crawl_with_proxy_rotation
              next if result.blank?

              fallback_result ||= result
              return result if result.stock_status == "in_stock"
            end

            return fallback_result if fallback_result.present?
          end

          raise StandardError, "Backmarket crawl failed after retries"
        end

        private

        attr_reader :backmarket_watch_target

        def crawl_with_proxy_rotation
          NAVIGATION_RETRY_COUNT.times do
            proxy = Crawl::DynamicProxy.get

            begin
              return crawl_with_proxy(proxy:)
            rescue StandardError => e
              invalidate_proxy_if_needed(proxy:, error: e)
              raise unless retryable_crawl_error?(e)
            end
          end

          nil
        end

        def crawl_with_proxy(proxy:)
          result = nil

          Crawl::CamoufoxClient.execute(proxy:) do |page|
            warmup_backmarket_session!(page)
            response = page.goto(backmarket_watch_target.url, waitUntil: "domcontentloaded", referer: BACKMARKET_BASE_URL)
            validate_response!(response)
            wait_for_stock_indicator(page)
            result = build_result(page)
          end

          result
        end

        def wait_for_stock_indicator(page)
          page.wait_for_selector(
            'span[data-qa="productpage-product-price"], [data-test="out-of-stock-product"]',
            timeout: WAIT_TIMEOUT_MS
          )
        end

        def build_result(page)
          current_stock_status = stock_status(page:)
          in_stock = current_stock_status == "in_stock"

          result = CrawlResult.new(
            name: product_name(page:),
            price: price(page:),
            condition: condition(page:),
            memory: in_stock ? spec_value(page:, key: "メモリ") : nil,
            storage: in_stock ? spec_value(page:, key: "容量 (GB)") : nil,
            cpu: in_stock ? cpu(page:) : nil,
            stock_status: current_stock_status
          )

          raise StandardError, result.errors.full_messages.join(", ") unless result.valid?

          result
        end

        def product_name(page:)
          page.query_selector("h1")&.inner_text&.squish
        end

        def price(page:)
          text = page.query_selector('span[data-qa="productpage-product-price"]')&.inner_text&.squish
          text&.gsub(/[^0-9]/, "")&.to_i
        end

        def condition(page:)
          page.query_selector_all("span").each do |span|
            text = span.inner_text.squish
            next unless text.match?(/^[ABC]グレード$/)
            next unless span.get_attribute("class").to_s.include?("body-1-bold")

            return text
          end

          nil
        end

        def cpu(page:)
          summary = page.query_selector('[data-test="selected-options"]')&.inner_text&.squish
          selected_cpu = extract_cpu_from_summary(summary)

          selected_cpu || spec_value(page:, key: "CPU")
        end

        def spec_value(page:, key:)
          labels = page.query_selector_all("dt").map { |node| node.inner_text.squish }
          values = page.query_selector_all("span.ml-24.block.text-right").map { |node| node.inner_text.squish }
          specs = labels.zip(values).to_h

          specs[key]
        end

        def stock_status(page:)
          return "out_of_stock" if page.query_selector('[data-test="out-of-stock-product"]').present?

          price_node = page.query_selector('span[data-qa="productpage-product-price"]')
          return "in_stock" if price_node.present?

          "out_of_stock"
        end

        def extract_cpu_from_summary(summary)
          return if summary.blank?

          matched = summary.match(/(Apple[^0-9]*M[0-9].*?GPU)/)
          matched&.captures&.first
        end

        def warmup_backmarket_session!(page)
          response = page.goto(BACKMARKET_BASE_URL, waitUntil: "domcontentloaded")
          validate_response!(response)
        end

        def validate_response!(response)
          status = response&.status.to_i
          return if status.between?(200, 299)

          raise RequestFailedError.new(status:)
        end

        def invalidate_proxy_if_needed(proxy:, error:)
          return if proxy.blank?
          return unless request_failed_error?(error)
          return unless PROXY_INVALIDATION_STATUS_CODES.include?(error.status)

          Crawl::DynamicProxy.remove(proxy:)
        end

        def request_failed_error?(error)
          error.is_a?(RequestFailedError)
        end

        def retryable_crawl_error?(error)
          request_failed_error?(error) ||
            error.class.name.include?("TargetClosedError") ||
            RETRYABLE_ERROR_MESSAGES.any? { |message| error.message.include?(message) }
        end

        class RequestFailedError < StandardError
          attr_reader :status

          def initialize(status:)
            @status = status.to_i
            super("request failed: #{status}")
          end
        end
      end
    end
  end
end
