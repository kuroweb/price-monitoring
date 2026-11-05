module ProductAggregationSettings
  # 条件に一致する商品計測結果のうち、期間内に売れたものを日ごとに集計する
  class CalculateResults
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze

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

    # 除外した出品は対象外。複数の商品計測設定に同じ出品がある場合は external_id で1件にまとめる
    def purchases_by_date
      @purchases_by_date ||=
        ProductCrawlResult
        .not_excluded
        .where(bought_date: start_date.in_time_zone.beginning_of_day..end_date.in_time_zone.end_of_day)
        .order(:id)
        .select { |result| Crawl::Search::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty? }
        .uniq(&:external_id)
        .group_by { |result| result.bought_date.in_time_zone.to_date }
    end

    def filter_params
      product_aggregation_setting.attributes.symbolize_keys.slice(*FILTER_KEYS)
    end
  end
end
