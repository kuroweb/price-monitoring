module Products
  module RefreshRelatedProduct
    class EnqueueRefreshJob
      include Sidekiq::Job

      sidekiq_options queue: :refresh_related_products, retry: 0

      def perform
        job_params = Product.all.pluck(:id).map { |p| [p] }
        RefreshJob.perform_bulk(job_params)
      end
    end
  end
end
