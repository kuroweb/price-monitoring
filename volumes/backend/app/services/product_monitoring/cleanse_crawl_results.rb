module ProductMonitoring
  # 保存済みの商品計測結果のうち、現在の条件に一致しないものを除外済みの行も含めて削除する
  class CleanseCrawlResults
    FILTER_KEYS = %i[required_keywords exclude_keywords min_price max_price].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(product_crawl_setting:)
      @product_crawl_setting = product_crawl_setting
    end

    def call
      ids = ProductCrawlResult.where(product_crawl_setting_id: product_crawl_setting.id).reject do |result|
        ProductMonitoring::Filter.call(item: result.attributes.symbolize_keys, params: filter_params).empty?
      end.map(&:id)
      ProductCrawlResult.where(id: ids).delete_all if ids.any?
    end

    private

    attr_reader :product_crawl_setting

    def filter_params
      product_crawl_setting.attributes.symbolize_keys.slice(*FILTER_KEYS)
    end
  end
end
