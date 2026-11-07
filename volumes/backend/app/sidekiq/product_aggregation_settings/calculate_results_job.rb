module ProductAggregationSettings
  class CalculateResultsJob
    include Sidekiq::Job

    sidekiq_options queue: :product_aggregation_settings_calculate_results, retry: 2

    def perform(product_aggregation_setting_id)
      product_aggregation_setting = ProductAggregationSetting.find_by(id: product_aggregation_setting_id)
      return unless product_aggregation_setting

      end_date = Time.zone.today
      ProductAggregationSettings::CalculateResults.call(
        product_aggregation_setting:,
        start_date: end_date - 29,
        end_date:
      )
    end
  end
end
