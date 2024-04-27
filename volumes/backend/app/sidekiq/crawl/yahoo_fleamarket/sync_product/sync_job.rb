module Crawl
  module YahooFleamarket
    module SyncProduct
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_yahoo_fleamarket_sync_product_sync_job, retry: 0

        def perform(yahoo_fleamarket_product_id)
          yahoo_fleamarket_product = YahooFleamarketProduct.find_by(id: yahoo_fleamarket_product_id)
          return if yahoo_fleamarket_product.nil?

          handle_timeout { Crawl::YahooFleamarket::SyncProduct::Syncer.call(yahoo_fleamarket_product:) }
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
