module ProductMonitoring
  module Search
    # after より後、up_to 以前に保存された、条件に一致する販売中の出品を新しい順に重複なく返す。新着通知に使う
    # サイト上の同じものが after 以前に保存されていれば新着にしない
    class NewlySavedCrawlResults
      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, after:, up_to:)
        @monitor = monitor
        @after = after
        @up_to = up_to
      end

      def call
        listings = candidates.order(id: :desc).select { |result| Monitor::Matcher.call(monitor:, listing: result) }
        listings = listings.uniq { |result| [result.platform, result.external_id] }
        saved = saved_before(listings)
        listings.reject { |result| saved.include?([result.platform, result.external_id]) }
      end

      private

      attr_reader :monitor, :after, :up_to

      # 価格帯は SQL で先に絞る。語句は Monitor::Matcher で判定する
      def candidates
        table = ProductMonitoring::CrawlResult.arel_table
        results = ProductMonitoring::CrawlResult.not_excluded.not_excluded_seller.where(sold: false)
                                                .where(table[:created_at].gt(after)).where(created_at: ..up_to)
        min_price = monitor.min_price
        max_price = monitor.max_price
        return results unless min_price || max_price

        results.where(price: min_price..max_price)
      end

      # 候補ごとに問い合わせず、external_id でまとめて引く
      def saved_before(listings)
        ProductMonitoring::CrawlResult.where(external_id: listings.map(&:external_id), created_at: ..after)
                                      .pluck(:platform, :external_id).to_set
      end
    end
  end
end
