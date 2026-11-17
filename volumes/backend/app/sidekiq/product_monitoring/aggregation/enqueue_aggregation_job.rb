module ProductMonitoring
  module Aggregation
    class EnqueueAggregationJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_enqueue_aggregation_job, retry: 0

      def perform
        job_params = ProductMonitoring::Monitor.pluck(:id).zip
        AggregationJob.perform_bulk(job_params)
      end
    end
  end
end
