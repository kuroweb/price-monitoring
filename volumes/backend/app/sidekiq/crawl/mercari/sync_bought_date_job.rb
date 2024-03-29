module Crawl
  module Mercari
    class SyncBoughtDateJob
      include Sidekiq::Job

      BATCH_SIZE = 500
      JOB_TIMEOUT = 30.minutes

      sidekiq_options queue: :crawl_mercari_sync_bought_date, retry: 0

      def perform
        handle_timeout do
          MercariProduct.where(
            published: false,
            bought_date: nil
          ).find_each(batch_size: BATCH_SIZE) do |mercari_product|
            Crawl::Mercari::SyncBoughtDate.call(mercari_product: mercari_product.reload)
          rescue StandardError
            Rails.logger.info("Skipping... mercari_id: #{mercari_product.mercari_id}")
          end
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
