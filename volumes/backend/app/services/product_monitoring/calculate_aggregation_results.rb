module ProductMonitoring
  # 条件に一致する商品計測結果のうち、期間内に売れたものを日ごとに集計する
  class CalculateAggregationResults
    def self.call(...)
      new(...).call
    end

    def initialize(product_aggregation_setting:, start_date:, end_date:)
      @product_aggregation_setting = product_aggregation_setting
      @start_date = start_date.to_date
      @end_date = end_date.to_date
    end

    def call
      rows = (start_date..end_date).map do |date|
        prices = purchases_by_date.fetch(date, []).map(&:price)
        {
          product_aggregation_setting_id: product_aggregation_setting.id,
          date:,
          average_purchase_price: prices.empty? ? nil : (prices.sum.to_f / prices.size).round,
          purchase_count: prices.size
        }
      end
      ProductAggregationResult.upsert_all(rows, record_timestamps: true)
    end

    private

    attr_reader :product_aggregation_setting, :start_date, :end_date

    def purchases_by_date
      @purchases_by_date ||=
        ProductMonitoring::AggregationPurchases
        .call(product_aggregation_setting:, start_date:, end_date:)
        .group_by { |result| result.bought_date.in_time_zone.to_date }
    end
  end
end
