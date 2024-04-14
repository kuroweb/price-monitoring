module Crawl
  module Mercari
    module SyncBoughtDate
      class SyncJob
        include Sidekiq::Job

        JOB_TIMEOUT = 30.minutes

        sidekiq_options queue: :crawl_mercari_sync_bought_date_sync_job, retry: 0

        def perform(mercari_product_id)
          handle_timeout do
            mercari_product = MercariProduct.find(mercari_product_id)
            Crawl::Mercari::SyncBoughtDate::Syncer.call(mercari_product:)
          end
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
