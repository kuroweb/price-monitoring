module Crawl
  module Mercari
    module SyncProducts
      class SyncJob
        include Sidekiq::Job
        include Utils::TimeoutHandler

        sidekiq_options queue: :crawl_mercari_sync_products_sync_job,
                        retry: 0, lock: :until_executed

        def perform(product_id)
          product = Product.find(product_id)
          handle_timeout { Crawl::Mercari::SyncProducts::Syncer.call(product:) }
        end
      end
    end
  end
end
