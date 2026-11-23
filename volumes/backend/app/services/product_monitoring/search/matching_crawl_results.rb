module ProductMonitoring
  module Search
    # 抽出条件に合う保存済みの収集結果を、重複なくすべて返す。モニタリング設定の詳細に使う。
    # 並びは recency_at の降順、同じ時刻は id の降順。recency_at がない行は末尾で、その中は id の降順。
    # 売れた日が未取得の売り切れは末尾にある。件数で走査を止めると、詳細の売り切れから落ちる。
    # 一覧の8件は NewestCrawlResults のままにする。
    class MatchingCrawlResults
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
          collect(listings, seen, candidates.where(recency_at: nil),
                  cursor: :id, order: :desc)
        end
        listings
      end

      private

      attr_reader :monitor

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        results = ProductMonitoring::CrawlResult.not_excluded
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
        end
      end
    end
  end
end
