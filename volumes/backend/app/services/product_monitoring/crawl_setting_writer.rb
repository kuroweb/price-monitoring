module ProductMonitoring
  class CrawlSettingWriter
    def self.call(product_crawl_setting:, params:)
      values = ProductMonitoring::Input.call(params:, require_name: true, require_search_urls: true)
      values[:search_urls].each { |url| ProductMonitoring::UrlRouter.call(url:) }

      ProductCrawlSetting.transaction do
        product_crawl_setting.update!(
          values.slice(:name, :enabled, :search_urls, :required_keywords, :exclude_keywords, :min_price, :max_price)
        )
        # 条件を変えたら、新しい条件に一致しなくなった保存済みの結果をすぐに取り除く
        if product_crawl_setting.saved_changes.keys.intersect?(CleanseCrawlResults::FILTER_KEYS.map(&:to_s))
          CleanseCrawlResults.call(product_crawl_setting:)
        end
      end
      product_crawl_setting
    end
  end
end
