module ProductMonitoring
  class LowestListings
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze
    BATCH_SIZE = 100

    def self.call(product_watch_setting:)
      filter = filter_params(product_watch_setting)
      lowest = []
      ProductCrawlResult.transaction do
        candidates(filter).find_each(
          cursor: %i[price id], order: %i[asc asc], batch_size: BATCH_SIZE
        ) do |result|
          break if lowest.any? && result.price > lowest.first.price
          next unless matches?(result, filter)

          lowest << result
        end
      end
      lowest.uniq { |result| [result.platform, result.external_id] }
    end

    def self.candidates(filter)
      results = ProductCrawlResult.not_excluded.where(sold: false)
      results = results.where(price: filter[:min_price]..filter[:max_price]) if filter[:min_price] || filter[:max_price]
      results
    end

    def self.filter_params(setting)
      setting.attributes.symbolize_keys.slice(*FILTER_KEYS)
    end

    def self.matches?(result, filter)
      ProductMonitoring::Filter.call(item: result.attributes.symbolize_keys, params: filter).empty?
    end
  end
end
