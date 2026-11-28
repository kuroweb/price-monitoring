module ProductMonitoring
  module Aggregation
    # 日次相場の集計対象になる取引。抽出条件に一致する収集結果のうち、期間内に売れたもの
    class Transactions
      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, start_date:, end_date:)
        @monitor = monitor
        @start_date = start_date.to_date
        @end_date = end_date.to_date
      end

      # 除外した収集結果は対象外。複数の収集設定に同じ出品がある場合は external_id で1件にまとめる
      def call
        ProductMonitoring::CrawlResult
          .not_excluded
          .not_excluded_seller
          .where(sold_at: start_date.in_time_zone.beginning_of_day..end_date.in_time_zone.end_of_day)
          .order(:id)
          .select { |result| Monitor::Matcher.call(monitor:, listing: result) }
          .uniq(&:external_id)
      end

      private

      attr_reader :monitor, :start_date, :end_date
    end
  end
end
