module Crawl
  module PcKoubou
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_pc_koubou_enqueue_sync_job, retry: 0

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        Crawl::Iosys::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
