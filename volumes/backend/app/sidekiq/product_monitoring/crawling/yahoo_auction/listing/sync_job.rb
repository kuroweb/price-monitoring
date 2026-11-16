module ProductMonitoring
  module Crawling
    module YahooAuction
      module Listing
        class SyncJob
          include Sidekiq::Job

          sidekiq_options queue: :product_monitoring_yahoo_auction_listing_sync_job,
                          retry: 2, lock: :until_executed

          JOB_TIMEOUT = 30.minutes

          def perform(product_crawl_setting_id, manual = nil)
            product_crawl_setting = ProductCrawlSetting.find_by(id: product_crawl_setting_id)
            return unless product_crawl_setting
            return if !manual && !product_crawl_setting.enabled?

            Timeout.timeout(JOB_TIMEOUT) { Syncer.call(product_crawl_setting:) }
          end
        end
      end
    end
  end
end
