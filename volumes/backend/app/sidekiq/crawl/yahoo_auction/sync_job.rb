module Crawl
  module YahooAuction
    class SyncJob
      include Sidekiq::Job

      def perform(yahoo_auction_product_id)
        yahoo_auction_product = YahooAuctionProduct.find(yahoo_auction_product_id)

        Crawl::YahooAuction::SyncService.call(yahoo_auction_product:)
      end
    end
  end
end
