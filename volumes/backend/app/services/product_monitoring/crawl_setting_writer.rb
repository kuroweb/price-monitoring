module ProductMonitoring
  class CrawlSettingWriter
    def self.call(product_crawl_setting:, params:)
      values = ProductMonitoring::Input.call(params:, require_name: true, require_search_urls: true)
      values[:search_urls].each { |url| ProductMonitoring::UrlRouter.call(url:) }

      product_crawl_setting.update!(
        values.slice(:name, :enabled, :search_urls, :required_keywords, :exclude_keywords, :min_price, :max_price)
      )
      product_crawl_setting
    end
  end
end
