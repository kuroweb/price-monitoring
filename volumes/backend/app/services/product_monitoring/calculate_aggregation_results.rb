module ProductMonitoring
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
        rows = (start_date..end_date).map do |date|
          prices = purchases_by_date.fetch(date, []).map(&:price)
          {
            product_watch_setting_id: product_watch_setting.id,
            date:,
            average_purchase_price: prices.empty? ? nil : (prices.sum.to_f / prices.size).round,
            purchase_count: prices.size
          }
        end
        ProductAggregationResult.upsert_all(rows, record_timestamps: true)
      end
    end

    private

    attr_reader :product_watch_setting, :start_date, :end_date

    def purchases_by_date
      @purchases_by_date ||=
        ProductMonitoring::AggregationPurchases
        .call(product_watch_setting:, start_date:, end_date:)
        .group_by { |result| result.bought_date.in_time_zone.to_date }
    end
  end
end
