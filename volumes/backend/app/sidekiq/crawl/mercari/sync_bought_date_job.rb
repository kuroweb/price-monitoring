module Crawl
  module Mercari
    class SyncBoughtDateJob
      include Sidekiq::Job

      BATCH_SIZE = 500

      sidekiq_options queue: :crawl_mercari_sync_bought_date, retry: 0

      def perform
        MercariProduct.where(published: false, bought_date: nil).find_each(batch_size: BATCH_SIZE) do |mercari_product|
          Crawl::Mercari::SyncBoughtDate.call(mercari_product: mercari_product.reload)
        end
      end
    end
  end
end
