module ProductMonitoring
  module Watching
    class NotificationJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_notification_job, retry: 0, lock: :until_executed

      def perform(id)
        setting = ProductWatchSetting.find_by(id:)
        return unless setting

        LowestPriceNotifier.call(product_watch_setting: setting)
      end
    end
  end
end
