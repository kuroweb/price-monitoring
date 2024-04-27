module Crawl
  module YahooFleamarket
    module SyncProducts
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 15.minutes

        sidekiq_options queue: :crawl_yahoo_fleamarket_sync_products_sync_job

        def perform(product_id)
          product = Product.find(product_id)
          handle_timeout { Crawl::YahooFleamarket::SyncProducts::Syncer.call(product:) }
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
