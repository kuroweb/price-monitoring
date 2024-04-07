module Products
  class RefreshRelatedProductsJob
    include Sidekiq::Job

    sidekiq_options queue: :refresh_related_products, retry: 0

    def perform(product_id)
      product = Product.find(product_id)
      Products::RefreshRelatedProducts.call(product:)
    end
  end
end
