module Crawl
  module YahooFleamarket
    module SyncProducts
      class EnqueueSyncJob
        include Sidekiq::Job

        sidekiq_options queue: :crawl_yahoo_fleamarket_sync_products_enqueue_sync_job, retry: 0

        def perform
          job_params = Product.joins(:yahoo_auction_crawl_setting).pluck(:id).map { |p| [p] }
          SyncJob.perform_bulk(job_params)
        end
      end
    end
  end
end
