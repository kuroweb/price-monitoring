module Crawl
  module Iosys
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_iosys_enqueue_sync_job, retry: 0

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        Crawl::Iosys::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
