module Crawl
  module Mercari
    module SyncProducts
      class SyncJob
        include Sidekiq::Job

        sidekiq_options queue: :crawl_mercari

        def perform(product_id)
          product = Product.find(product_id)
          Crawl::Mercari::SyncProducts::Syncer.call(product:)
        end
      end
    end
  end
end