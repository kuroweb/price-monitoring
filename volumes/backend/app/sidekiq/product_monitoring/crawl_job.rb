module ProductMonitoring
  class CrawlJob
    include Sidekiq::Job
    include Utils::TimeoutHandler

    sidekiq_options queue: :product_monitoring_crawl_job,
                    retry: 2, lock: :until_executed

    def perform(product_crawl_setting_id, manual = nil)
      product_crawl_setting = ProductCrawlSetting.find_by(id: product_crawl_setting_id)
      return if product_crawl_setting && !manual && !product_crawl_setting.enabled?
      return unless product_crawl_setting

      handle_timeout { ::ProductMonitoring::SyncCrawlResults.call(product_crawl_setting:) }
    end
  end
end
