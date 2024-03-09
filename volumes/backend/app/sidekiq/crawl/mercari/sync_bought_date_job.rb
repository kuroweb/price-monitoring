module Crawl
  module Mercari
    class SyncBoughtDateJob
      include Sidekiq::Job

      def perform(mercari_id)
        mercari_product = MercariProduct.find_by(mercari_id:)
        return if mercari_product.nil?

        Crawl::Mercari::SyncBoughtDate.call(mercari_product:)
      end
    end
  end
end
