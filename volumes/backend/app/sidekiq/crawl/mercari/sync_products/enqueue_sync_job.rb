module Crawl
  module Mercari
    module SyncProducts
      class EnqueueSyncJob
        include Sidekiq::Job

        sidekiq_options queue: :crawl_mercari

        def perform
          job_params = Product.all.pluck(:id).map { |p| [p] }
          Crawl::Mercari::SyncProducts::SyncJob.perform_bulk(job_params)
        end
      end
    end
  end
end
