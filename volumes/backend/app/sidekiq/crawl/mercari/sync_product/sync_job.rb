module Crawl
  module Mercari
    module SyncProduct
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_mercari_sync_product_sync_job, retry: 0

        def perform(mercari_product_id)
          mercari_product = MercariProduct.find_by(id: mercari_product_id)
          return if mercari_product.nil

          handle_timeout { Crawl::Mercari::SyncProduct::Syncer.call(mercari_product:) }
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
