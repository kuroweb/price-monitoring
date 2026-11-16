module ProductMonitoring
  module Watching
    # 条件に一致する商品計測結果のうち、期間内に売れたものを日ごとに集計する
    class CalculateAggregationResults
      def self.call(...)
        new(...).call
      end

      def initialize(product_watch_setting:, start_date:, end_date:)
        @product_watch_setting = product_watch_setting
        @start_date = start_date.to_date
        @end_date = end_date.to_date
      end

      def call
        product_watch_setting.with_lock do
          rows = (start_date..end_date).map { |date| row(date, purchases_by_date.fetch(date, []).map(&:price)) }
          # 期間の全日を1文で書き込む。日次相場は検証の対象になる入力ではないので、モデルの検証は通さない
          ProductAggregationResult.upsert_all(rows, record_timestamps: true) # rubocop:disable Rails/SkipsModelValidations
        end
      end

      private

      def row(date, prices)
        {
          product_watch_setting_id: product_watch_setting.id,
          date:,
          average_purchase_price: prices.empty? ? nil : (prices.sum.to_f / prices.size).round,
          purchase_count: prices.size
        }
      end

      attr_reader :product_watch_setting, :start_date, :end_date

      def purchases_by_date
        @purchases_by_date ||=
          AggregationPurchases
          .call(product_watch_setting:, start_date:, end_date:)
          .group_by { |result| result.bought_date.in_time_zone.to_date }
      end
    end
  end
end
