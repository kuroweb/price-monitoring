module Products
  class EnqueueRefreshProductJob
    include Sidekiq::Job

    sidekiq_options queue: :refresh_product, retry: 0

    def perform
      job_params = Product.all.pluck(:id).map { |p| [p] }
      Products::RefreshProductJob.perform_bulk(job_params)
    end
  end
end
