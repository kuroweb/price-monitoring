module Crawl
  module YahooAuction
    class EnqueueSyncJob
      include Sidekiq::Job

      def perform
        job_params = YahooAuctionProduct.published.all.pluck(:id).map { |p| [p] }

        Crawl::YahooAuction::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
