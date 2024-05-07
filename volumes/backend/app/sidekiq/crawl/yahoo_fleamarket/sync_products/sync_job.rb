module Crawl
  module YahooFleamarket
    module SyncProducts
      class SyncJob
        include Sidekiq::Job
        include Utils::TimeoutHandler

        sidekiq_options queue: :crawl_yahoo_fleamarket_sync_products_sync_job,
                        retry: 0, lock: :until_executed

        def perform(product_id)
          product = Product.find(product_id)
          handle_timeout { Crawl::YahooFleamarket::SyncProducts::Syncer.call(product:) }
        end
      end
    end
  end
end
