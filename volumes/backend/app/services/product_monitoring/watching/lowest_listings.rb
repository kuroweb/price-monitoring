module ProductMonitoring
  module Watching
    # 条件に一致する販売中の出品のうち、最安値と同じ価格のものを返す。通知の判定に使う
    class LowestListings
      BATCH_SIZE = 100

      def self.call(...)
        new(...).call
      end

      def initialize(product_watch_setting:)
        @product_watch_setting = product_watch_setting
      end

      def call
        lowest = []
        ProductCrawlResult.transaction do
          candidates.find_each(cursor: %i[price id], order: %i[asc asc], batch_size: BATCH_SIZE) do |result|
            break if lowest.any? && result.price > lowest.first.price
            next unless WatchSettings::Matcher.call(product_watch_setting:, listing: result)

            lowest << result
          end
        end
        lowest.uniq { |result| [result.platform, result.external_id] }
      end

      private

      attr_reader :product_watch_setting

      # 価格帯は SQL で先に絞る。語句は WatchSettings::Matcher で判定する
      def candidates
        results = ProductCrawlResult.not_excluded.where(sold: false)
        min_price = product_watch_setting.min_price
        max_price = product_watch_setting.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end
    end
  end
end
