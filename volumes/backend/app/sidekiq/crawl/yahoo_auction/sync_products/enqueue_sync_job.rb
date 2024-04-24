module Crawl
  module YahooAuction
    module SyncProducts
      class EnqueueSyncJob
        include Sidekiq::Job

        sidekiq_options queue: :crawl_yahoo_auction_sync_products_enqueue_sync_job, retry: 0

        def perform
          job_params = Product.all.pluck(:id).map { |p| [p] }
          SyncJob.perform_bulk(job_params)
        end
      end
    end
  end
end
