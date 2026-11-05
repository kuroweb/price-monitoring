module ProductCrawlSettings
  class Writer
    def self.call(product_crawl_setting:, params:)
      values = Crawl::Search::Input.call(params:, require_name: true, require_search_urls: true)
      values[:search_urls].each { |url| Crawl::Search::UrlRouter.call(url:) }

      product_crawl_setting.update!(
        values.slice(:name, :enabled, :search_urls, :required_keywords, :exclude_keywords, :exclude_external_ids,
                     :min_price, :max_price)
      )
      product_crawl_setting
    end
  end
end
