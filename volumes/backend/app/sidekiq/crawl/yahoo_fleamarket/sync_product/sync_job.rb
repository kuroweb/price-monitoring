module Crawl
  module YahooFleamarket
    module SyncProduct
      class SyncJob
        include Sidekiq::Job
        include Utils::TimeoutHandler

        sidekiq_options queue: :crawl_yahoo_fleamarket_sync_product_sync_job,
                        retry: 0, lock: :until_executed

        def perform(yahoo_fleamarket_product_id)
          yahoo_fleamarket_product = YahooFleamarketProduct.find_by(id: yahoo_fleamarket_product_id)
          return if yahoo_fleamarket_product.nil?

          handle_timeout { Crawl::YahooFleamarket::SyncProduct::Syncer.call(yahoo_fleamarket_product:) }
        end
      end
    end
  end
end
