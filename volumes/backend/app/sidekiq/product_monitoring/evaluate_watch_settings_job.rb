module ProductMonitoring
  class EvaluateWatchSettingsJob
    include Sidekiq::Job

    sidekiq_options queue: :product_monitoring_evaluate_watch_settings_job, retry: 0, lock: :until_executed

    def perform
      ProductWatchSetting.where(enabled: true).in_batches do |settings|
        ProductMonitoring::EvaluateWatchSettingJob.perform_bulk(settings.pluck(:id).zip)
      end
    end
  end
end
