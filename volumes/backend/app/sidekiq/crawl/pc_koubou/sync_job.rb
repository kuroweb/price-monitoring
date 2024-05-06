module Crawl
  module PcKoubou
    class SyncJob
      include Sidekiq::Job

      JOB_TIMEOUT = 30.minutes

      sidekiq_options queue: :crawl_pc_koubou_sync_job,
                      retry: 0, lock: :until_executed

      def perform(product_id)
        product = Product.find(product_id)
        handle_timeout { Crawl::PcKoubou::Syncer.call(product:) }
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
