module Crawl
  module YahooAuction
    class EnqueueCrawlJob
      include Sidekiq::Job

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }

        Crawl::YahooAuction::CrawlJob.perform_bulk(job_params)
      end
    end
  end
end
