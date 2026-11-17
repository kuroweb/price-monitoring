module ProductMonitoring
  module Aggregation
    # 抽出条件に一致する収集結果のうち、期間内に売れた取引を日ごとに集計する
    class AggregateDailyMarketPrices
      def self.call(...)
        new(...).call
      end

      def initialize(monitor:, start_date:, end_date:)
        @monitor = monitor
        @start_date = start_date.to_date
        @end_date = end_date.to_date
      end

      def call
        monitor.with_lock do
          rows = (start_date..end_date).map { |date| row(date, purchases_by_date.fetch(date, []).map(&:price)) }
          # 期間の全日を1文で書き込む。日次相場は検証の対象になる入力ではないので、モデルの検証は通さない
          ProductMonitoring::DailyMarketPrice.upsert_all(rows, record_timestamps: true) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      private

      def row(date, prices)
        {
          monitor_id: monitor.id,
          date:,
          average_transaction_price: prices.empty? ? nil : (prices.sum.to_f / prices.size).round,
          transaction_count: prices.size
        }
      end

      attr_reader :monitor, :start_date, :end_date

      def purchases_by_date
        @purchases_by_date ||=
          Transactions
          .call(monitor:, start_date:, end_date:)
          .group_by { |result| result.sold_at.in_time_zone.to_date }
      end
    end
  end
end
