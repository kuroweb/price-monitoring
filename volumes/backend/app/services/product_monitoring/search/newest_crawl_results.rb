module ProductMonitoring
  module Search
    # 条件に一致する出品を、売り切れも含めて新着順に重複なく最大8件返す。画面の表示に使う。
    # 新着は初めて保存した日時（created_at）の降順。id は並列な保存で日時と前後するので使わない。
    # 同じ日時は id の降順。created_at がない行は末尾で、その中も id の降順。
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
          # created_at が null の行は find_each のカーソルにできないので、日時がある行のあとで読む
          collect(listings, seen, candidates.where.not(created_at: nil),
                  cursor: %i[created_at id], order: %i[desc desc])
          collect(listings, seen, candidates.where(created_at: nil), order: :desc) if listings.size < LIMIT
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
          break if listings.size == LIMIT
        end
      end
    end
  end
end
