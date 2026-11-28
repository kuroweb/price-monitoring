module ProductMonitoring
  module Search
    # 条件に一致する販売中の出品のうち、最安値と同じ価格のものを返す。通知の判定に使う
    class LowestCrawlResults
      BATCH_SIZE = 100

      def self.call(...)
        new(...).call
      end

      def initialize(monitor:)
        @monitor = monitor
      end

      def call
        lowest = []
        ProductMonitoring::CrawlResult.transaction do
          candidates.find_each(cursor: %i[price id], order: %i[asc asc], batch_size: BATCH_SIZE) do |result|
            break if lowest.any? && result.price > lowest.first.price
            next unless Monitor::Matcher.call(monitor:, listing: result)

            lowest << result
          end
        end
        lowest.uniq { |result| [result.platform, result.external_id] }
      end

      private

      attr_reader :monitor

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        results = ProductMonitoring::CrawlResult.not_excluded.not_excluded_seller.where(sold: false)
        min_price = monitor.min_price
        max_price = monitor.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end
    end
  end
end
