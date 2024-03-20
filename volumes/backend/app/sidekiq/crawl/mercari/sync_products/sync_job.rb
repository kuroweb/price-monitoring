module Crawl
  module Mercari
    module SyncProducts
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_mercari, retry: 5

        def perform(product_id)
          product = Product.find(product_id)
          handle_timeout { Crawl::Mercari::SyncProducts::Syncer.call(product:) }
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
