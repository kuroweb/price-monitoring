module Crawl
  module UsedSofmap
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_used_sofmap_enqueue_sync_job, retry: 0

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        Crawl::UsedSofmap::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
