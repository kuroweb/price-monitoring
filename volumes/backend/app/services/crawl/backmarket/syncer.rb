module Crawl
  module Backmarket
    class Syncer
      COMPARISON_ATTRIBUTES = %w[
        name
        price
        condition
        memory
        storage
        cpu
        stock_status
      ].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:)
        @backmarket_watch_target = backmarket_watch_target
      end

      def call
        return unless backmarket_watch_target.enabled?

        previous_result = latest_result
        result = crawler_result
        return if unchanged?(result:, previous_result:)

        current_result = create_result!(result)
        notify_diff_if_needed(previous_result:, current_result:)
      end

      private

      attr_reader :backmarket_watch_target

      def create_result!(result)
        backmarket_watch_target.backmarket_watch_results.create!(
          result.attributes.merge("crawled_at" => Time.current)
        )
      end

      def unchanged?(result:, previous_result:)
        return false if previous_result.blank?

        COMPARISON_ATTRIBUTES.all? do |attribute|
          previous_result.public_send(attribute) == result.public_send(attribute)
        end
      end

      def notify_diff_if_needed(previous_result:, current_result:)
        reasons = diff_reasons(previous_result:, current_result:)
        return if reasons.empty?

        DiscordNotifier.call(
          backmarket_watch_target:,
          backmarket_watch_result: current_result,
          reasons:
        )
      end

      def diff_reasons(previous_result:, current_result:)
        return [] if previous_result.blank?

        reasons = []
        reasons << :price_dropped if price_dropped?(previous_result:, current_result:)
        reasons << :restocked if restocked?(previous_result:, current_result:)
        reasons
      end

      def price_dropped?(previous_result:, current_result:)
        previous_result.price.present? &&
          current_result.price.present? &&
          current_result.price < previous_result.price
      end

      def restocked?(previous_result:, current_result:)
        previous_result.stock_status == "out_of_stock" &&
          current_result.stock_status == "in_stock"
      end

      def latest_result
        @latest_result ||= backmarket_watch_target.backmarket_watch_results.order(crawled_at: :desc).first
      end

      def crawler_result
        @crawler_result ||= Crawler.call(backmarket_watch_target:)
      end
    end
  end
end
