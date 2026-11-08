module ProductMonitoring
  class EvaluateWatchSettingJob
    include Sidekiq::Job

    sidekiq_options queue: :product_monitoring_evaluate_watch_settings_job, retry: 0, lock: :until_executed

    def perform(id)
      setting = ProductWatchSetting.find_by(id:)
      return unless setting

      ProductMonitoring::LowestPriceNotifier.call(product_watch_setting: setting)
    rescue StandardError => e
      Rails.logger.error("[ProductMonitoring::EvaluateWatchSettingJob] Failed setting #{id}: #{e.class}")
    end
  end
end
