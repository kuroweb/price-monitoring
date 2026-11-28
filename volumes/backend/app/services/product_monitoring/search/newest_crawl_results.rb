module ProductMonitoring
  module Search
    # 条件に一致する出品を、重複なく最大8件返す。モニタリング設定のカードに使う。
    # 並びは recency_at の降順、同じ時刻は id の降順。recency_at がない行は出さない。
    class NewestCrawlResults
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
          collect(listings, seen, candidates.where.not(recency_at: nil),
                  cursor: %i[recency_at id], order: %i[desc desc])
        end
        listings
      end

      private

      attr_reader :monitor

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        results = ProductMonitoring::CrawlResult.not_excluded.not_excluded_seller
        min_price = monitor.min_price
        max_price = monitor.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end

      def collect(listings, seen, scope, **batch)
        scope.find_each(batch_size: BATCH_SIZE, **batch) do |result|
          next unless Monitor::Matcher.call(monitor:, listing: result)
          next unless seen.add?([result.platform, result.external_id])

          listings << result
          break if listings.size == LIMIT
        end
      end
    end
  end
end
