module Crawl
  module YahooAuction
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_yahoo_auction

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        Crawl::YahooAuction::SyncJob.perform_bulk(job_params)
      end
    end
  end
end
