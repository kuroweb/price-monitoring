module Crawl
  module Mercari
    module SyncBoughtDate
      class EnqueueSyncJob
        include Sidekiq::Job

        sidekiq_options queue: :crawl_mercari_sync_bought_date_enqueue_sync_job, retry: 0

        def perform
          job_params = MercariProduct.where(published: false, bought_date: nil).pluck(:id).map { |p| [p] }
          SyncJob.perform_bulk(job_params)
        end
      end
    end
  end
end
