module Crawl
  module YahooAuction
    class CrawlJob
      include Sidekiq::Job

      def perform(product_id)
        product = Product.find(product_id)

        Crawl::YahooAuction::CrawlService.call(product:)
      end
    end
  end
end
