module Crawl
  module Janpara
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_janpara_enqueue_sync_job, retry: 0

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        Crawl::Janpara::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
