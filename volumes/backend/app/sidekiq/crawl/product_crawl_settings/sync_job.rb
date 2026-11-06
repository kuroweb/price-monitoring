module Crawl
  module ProductCrawlSettings
    class SyncJob
      include Sidekiq::Job
      include Utils::TimeoutHandler

      sidekiq_options queue: :crawl_product_crawl_settings_sync_job,
                      retry: 2, lock: :until_executed

      def perform(product_crawl_setting_id)
        product_crawl_setting = ProductCrawlSetting.find_by(id: product_crawl_setting_id, enabled: true)
        return unless product_crawl_setting

        handle_timeout { ::ProductCrawlSettings::SyncResults.call(product_crawl_setting:) }
      end
    end
  end
end
