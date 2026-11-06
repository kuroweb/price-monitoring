module ProductAggregationSettings
  class Writer
    def self.call(product_aggregation_setting:, params:)
      values = Crawl::Search::Input.call(params:, require_name: true)
      product_aggregation_setting.update!(values.slice(:name, :required_keywords, :exclude_keywords, :min_price,
                                                       :max_price))
      product_aggregation_setting
    end
  end
end
