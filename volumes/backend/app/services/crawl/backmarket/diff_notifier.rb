module Crawl
  module Backmarket
    class DiffNotifier
      RECENT_WINDOW = 1.day

      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:, current_result:)
        @backmarket_watch_target = backmarket_watch_target
        @current_result = current_result
      end

      def call
        return if duplicate_in_recent_window?

        reasons = diff_reasons
        return if reasons.empty?

        DiscordNotifier.call(
          backmarket_watch_target:,
          backmarket_watch_result: current_result,
          reasons:
        )
      end

      private

      attr_reader :backmarket_watch_target, :current_result

      def duplicate_in_recent_window?
        recent_results.any? { |record| same_values?(record) }
      end

      def same_values?(record)
        ResultCreator::COMPARISON_ATTRIBUTES.all? do |attribute|
          record.public_send(attribute) == current_result.public_send(attribute)
        end
      end

      def diff_reasons
        return [] if previous_result.blank?

        reasons = []
        reasons << :price_dropped if price_dropped?
        reasons << :restocked if restocked?
        reasons
      end

      def price_dropped?
        previous_result.price.present? &&
          current_result.price.present? &&
          current_result.price < previous_result.price
      end

      def restocked?
        previous_result.stock_status == "out_of_stock" &&
          current_result.stock_status == "in_stock"
      end

      def previous_result
        @previous_result ||= backmarket_watch_target.backmarket_watch_results
          .where.not(id: current_result.id)
          .order(crawled_at: :desc)
          .first
      end

      def recent_results
        @recent_results ||= backmarket_watch_target.backmarket_watch_results
          .where(crawled_at: RECENT_WINDOW.ago..)
          .where.not(id: current_result.id)
          .order(crawled_at: :desc)
      end
    end
  end
end
