module Crawl
  module Mercari
    module SyncProduct
      class SyncBoughtDateJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_mercari_sync_product_sync_bought_date_job, retry: 0

        def perform(mercari_product_id)
          mercari_product = MercariProduct.find(mercari_product_id)
          return unless executable?(mercari_product)

          handle_timeout { Crawl::Mercari::SyncProduct::Syncer.call(mercari_product:) }
        end

        def executable?(mercari_product)
          mercari_product.product.mercari_crawl_setting.enabled? \
            && !mercari_product.published \
            && mercari_product.bought_date.nil?
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
