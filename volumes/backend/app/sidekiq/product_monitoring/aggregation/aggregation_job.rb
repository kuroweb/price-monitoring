module ProductMonitoring
  module Aggregation
    class AggregationJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_aggregation_job, retry: 2

      def perform(monitor_id)
        monitor = ProductMonitoring::Monitor.find_by(id: monitor_id)
        return unless monitor

        end_date = Time.zone.today
        AggregateDailyMarketPrices.call(
          monitor:,
          start_date: end_date - 29,
          end_date:
        )
      end
    end
  end
end
