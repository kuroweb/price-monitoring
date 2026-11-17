module ProductMonitoring
  module Crawling
    module Janpara
      module ListPage
        class SyncJob
          include Sidekiq::Job

          sidekiq_options queue: :product_monitoring_janpara_list_page_sync_job,
                          retry: 2, lock: :until_executed

          JOB_TIMEOUT = 30.minutes

          def perform(crawl_setting_id, manual = nil)
            crawl_setting = ProductMonitoring::CrawlSetting.find_by(id: crawl_setting_id)
            return unless crawl_setting
            return if !manual && !crawl_setting.enabled?

            Timeout.timeout(JOB_TIMEOUT) { Syncer.call(crawl_setting:) }
          end
        end
      end
    end
  end
end
