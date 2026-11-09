module ProductMonitoring
  class AggregationJob
    include Sidekiq::Job

    sidekiq_options queue: :product_monitoring_aggregation_job, retry: 2

    def perform(product_watch_setting_id)
      product_watch_setting = ProductWatchSetting.find_by(id: product_watch_setting_id)
      return unless product_watch_setting

      end_date = Time.zone.today
      ProductMonitoring::CalculateAggregationResults.call(
        product_watch_setting:,
        start_date: end_date - 29,
        end_date:
      )
    end
  end
end
