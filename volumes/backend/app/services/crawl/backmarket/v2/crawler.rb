module Crawl
  module Backmarket
    module V2
      class Crawler
        CHALLENGE_WAIT_SECONDS = 10
        RETRY_COUNT = 5
        REQUEST_COUNT = 10
        SLEEP_SECONDS = 5
        WAIT_TIMEOUT_MS = 15_000

        def self.call(...)
          new(...).call
        end

        def initialize(backmarket_watch_target:)
          @backmarket_watch_target = backmarket_watch_target
        end

        def call
          Retryable.retryable(tries: RETRY_COUNT) do
            fallback_result = nil

            Crawl::CamoufoxClient.execute do |navigation|
              REQUEST_COUNT.times do
                sleep SLEEP_SECONDS

                navigation.goto(url: backmarket_watch_target.url)
                sleep CHALLENGE_WAIT_SECONDS
                wait_for_stock_indicator(navigation.page)

                result = build_result(navigation.page)
                fallback_result ||= result

                return result if result.stock_status == "in_stock"
              end
            end

            return fallback_result if fallback_result.present?
          end

          raise StandardError, "Backmarket crawl failed after retries"
        end

        private

        attr_reader :backmarket_watch_target

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
      end
    end
  end
end
