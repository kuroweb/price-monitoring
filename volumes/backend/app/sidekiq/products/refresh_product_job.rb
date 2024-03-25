module Products
  class RefreshProductJob
    include Sidekiq::Job

    sidekiq_options queue: :refresh_product, retry: 0

    def perform(product_id)
      product = Product.find(product_id)
      Products::YahooAuctionProducts::DeleteByCrawlSetting.call(product:)
      Products::MercariProducts::DeleteByCrawlSetting.call(product:)
    end
  end
end
