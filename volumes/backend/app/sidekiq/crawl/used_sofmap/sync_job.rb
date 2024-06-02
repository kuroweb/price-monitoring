module Crawl
  module UsedSofmap
    class SyncJob
      include Sidekiq::Job
      include Utils::TimeoutHandler

      sidekiq_options queue: :crawl_used_sofmap_sync_job,
                      retry: 0, lock: :until_executed

      def perform(product_id)
        product = Product.find(product_id)
        handle_timeout { Crawl::UsedSofmap::Syncer.call(product:) }
      end
    end
  end
end
