module Crawl
  module Mercari
    class SyncBoughtDateJob
      include Sidekiq::Job

      sidekiq_options queue: :crawl_mercari_sync_bought_date

      def perform(mercari_id)
        mercari_product = MercariProduct.find_by(mercari_id:)
        return if mercari_product.nil?

        Crawl::Mercari::SyncBoughtDate.call(mercari_product:)
      end
    end
  end
end
