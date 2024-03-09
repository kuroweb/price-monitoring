module Crawl
  module YahooAuction
    class SyncJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_yahoo_auction

      def perform(product_id)
        product = Product.find(product_id)
        Crawl::YahooAuction::Syncer.call(product:)
      end
    end
  end
end
