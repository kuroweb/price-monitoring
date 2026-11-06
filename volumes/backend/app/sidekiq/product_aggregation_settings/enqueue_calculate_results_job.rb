module ProductAggregationSettings
  class EnqueueCalculateResultsJob
    include Sidekiq::Job

    sidekiq_options queue: :product_aggregation_settings_enqueue_calculate_results, retry: 0

    def perform
      job_params = ProductAggregationSetting.pluck(:id).zip
      ProductAggregationSettings::CalculateResultsJob.perform_bulk(job_params)
    end
  end
end
