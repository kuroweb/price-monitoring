module ProductMonitoring
  class EnqueueAggregationJobsJob
    include Sidekiq::Job

    sidekiq_options queue: :product_monitoring_enqueue_aggregation_jobs_job, retry: 0

    def perform
      job_params = ProductAggregationSetting.pluck(:id).zip
      ProductMonitoring::AggregationJob.perform_bulk(job_params)
    end
  end
end
