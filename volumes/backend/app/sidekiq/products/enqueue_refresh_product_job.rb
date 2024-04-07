module Products
  class EnqueueRefreshRelatedProductsJob
    include Sidekiq::Job

    sidekiq_options queue: :refresh_related_products, retry: 0

    def perform
      job_params = Product.all.pluck(:id).map { |p| [p] }
      Products::RefreshRelatedProductsJob.perform_bulk(job_params)
    end
  end
end
