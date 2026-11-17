module ProductMonitoring
  module Search
    # 条件に一致する販売中の出品を、安い順に重複なく最大8件返す。画面の表示に使う
    class MonitorCrawlResults
      LIMIT = 8
      BATCH_SIZE = 100

      def self.call(...)
        new(...).call
      end

      def initialize(monitor:)
        @monitor = monitor
      end

      def call
        listings = []
        seen = Set.new
        ProductMonitoring::CrawlResult.transaction do
          candidates.find_each(cursor: %i[price id], order: %i[asc asc], batch_size: BATCH_SIZE) do |result|
            next unless Monitor::Matcher.call(monitor:, listing: result)
            next unless seen.add?([result.platform, result.external_id])

            listings << result
            break if listings.size == LIMIT
          end
        end
        listings
      end

      private

      attr_reader :monitor

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        results = ProductMonitoring::CrawlResult.not_excluded.where(sold: false)
        min_price = monitor.min_price
        max_price = monitor.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end
    end
  end
end
