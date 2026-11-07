module ProductCrawlSettings
  class EnqueueSyncJob
    include Sidekiq::Job

    sidekiq_options queue: :product_crawl_settings_enqueue_sync_job, retry: 0

    def perform
      job_params = ProductCrawlSetting.where(enabled: true).pluck(:id).zip
      ProductCrawlSettings::SyncJob.perform_bulk(job_params)
    end
  end
end
