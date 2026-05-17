module Crawl
  module Backmarket
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_backmarket_enqueue_sync_job, retry: 0

      def perform
        job_params = BackmarketWatchTarget.where(enabled: true).pluck(:id).zip
        Crawl::Backmarket::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
