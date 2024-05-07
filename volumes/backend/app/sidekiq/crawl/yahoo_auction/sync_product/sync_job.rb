module Crawl
  module YahooAuction
    module SyncProduct
      class SyncJob
        include Sidekiq::Job
        include Utils::TimeoutHandler

        sidekiq_options queue: :crawl_yahoo_auction_sync_product_sync_job,
                        retry: 0, lock: :until_executed

        def perform(yahoo_auction_product_id)
          yahoo_auction_product = YahooAuctionProduct.find_by(id: yahoo_auction_product_id)
          return if yahoo_auction_product.nil?

          handle_timeout { Crawl::YahooAuction::SyncProduct::Syncer.call(yahoo_auction_product:) }
        end
      end
    end
  end
end
