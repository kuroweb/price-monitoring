module ProductMonitoring
  module Notification
    class NotificationJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_notification_job, retry: 0, lock: :until_executed

      def perform(id)
        setting = ProductMonitoring::Monitor.find_by(id:)
        return unless setting

        LowestPriceNotifier.call(monitor: setting)
        NewestNotifier.call(monitor: setting)
      end
    end
  end
end
