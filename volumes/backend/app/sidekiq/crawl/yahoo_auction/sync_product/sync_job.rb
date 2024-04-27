module Crawl
  module YahooAuction
    module SyncProduct
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_yahoo_auction_sync_product_sync_job, retry: 0

        def perform(yahoo_auction_product_id)
          yahoo_auction_product = YahooAuctionProduct.find_by(id: yahoo_auction_product_id)
          return if yahoo_auction_product.nil?

          handle_timeout { Crawl::YahooAuction::SyncProduct::Syncer.call(yahoo_auction_product:) }
        end

        def handle_timeout(&block)
          Timeout.timeout(JOB_TIMEOUT, &block)
        rescue Timeout::Error => e
          Rails.logger.error("This worker has reached timeout.")
          raise e
        end
      end
    end
  end
end
