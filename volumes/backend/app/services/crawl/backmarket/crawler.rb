module Crawl
  module Backmarket
    class Crawler
      REQUEST_COUNT = 5

      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:)
        @backmarket_watch_target = backmarket_watch_target
      end

      def call
        fallback_result = nil

        REQUEST_COUNT.times do
          response = Crawl::BackmarketClient.get(url:)
          raise StandardError, "request failed: #{response.status}" unless response.success?

          result = build_result(response.body)
          fallback_result ||= result

          return result if result.stock_status == "in_stock"
        end

        fallback_result
      end

      private

      attr_reader :backmarket_watch_target

      delegate :url, to: :backmarket_watch_target

      def build_result(body)
        doc = Nokogiri::HTML(body)
        current_stock_status = stock_status(doc:)
        in_stock = current_stock_status == "in_stock"

        result = CrawlResult.new(
          name: product_name(doc:),
          price: price(doc:),
          condition: condition(doc:),
          memory: in_stock ? spec_value(doc:, key: "メモリ") : nil,
          storage: in_stock ? spec_value(doc:, key: "容量 (GB)") : nil,
          cpu: in_stock ? cpu(doc:) : nil,
          stock_status: current_stock_status
        )

        raise StandardError, result.errors.full_messages.join(", ") unless result.valid?

        result
      end

      def product_name(doc:)
        doc.at_css("h1")&.text&.squish
      end

      def price(doc:)
        text = doc.at_css('span[data-qa="productpage-product-price"]')&.text&.squish
        text&.gsub(/[^0-9]/, "")&.to_i
      end

      def condition(doc:)
        node = doc.css("span").find do |span|
          text = span.text.squish
          text.match?(/^[ABC]グレード$/) && span["class"].to_s.include?("body-1-bold")
        end

        node&.text&.squish
      end

      def cpu(doc:)
        summary = doc.at_css('[data-test="selected-options"]')&.text&.squish
        selected_cpu = extract_cpu_from_summary(summary)

        selected_cpu || spec_value(doc:, key: "CPU")
      end

      def spec_value(doc:, key:)
        labels = doc.css("dt").map { |node| node.text.squish }
        values = doc.css("span.ml-24.block.text-right").map { |node| node.text.squish }
        specs = labels.zip(values).to_h

        specs[key]
      end

      def stock_status(doc:)
        out_of_stock = doc.at_css('[data-test="out-of-stock-product"]')
        return "out_of_stock" if out_of_stock.present?

        price_node = doc.at_css('span[data-qa="productpage-product-price"]')
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
