module ProductMonitoring
  # 商品相場の集計対象になる購入。条件に一致する商品計測結果のうち、期間内に売れたもの
  class AggregationPurchases
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(product_aggregation_setting:, start_date:, end_date:)
      @product_aggregation_setting = product_aggregation_setting
      @start_date = start_date.to_date
      @end_date = end_date.to_date
    end

    # 除外した出品は対象外。複数の商品計測設定に同じ出品がある場合は external_id で1件にまとめる
    def call
      ProductCrawlResult
        .not_excluded
        .where(bought_date: start_date.in_time_zone.beginning_of_day..end_date.in_time_zone.end_of_day)
        .order(:id)
        .select { |result| ProductMonitoring::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty? }
        .uniq(&:external_id)
    end

    private

    attr_reader :product_aggregation_setting, :start_date, :end_date

    def filter_params
      product_aggregation_setting.attributes.symbolize_keys.slice(*FILTER_KEYS)
    end
  end
end
