module ProductMonitoring
  module Notification
    class EnqueueNotificationJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_enqueue_notification_job, retry: 0, lock: :until_executed

      def perform
        monitors = ProductMonitoring::Monitor
        monitors.where(enabled: true).or(monitors.where(newest_notification_enabled: true)).in_batches do |settings|
          NotificationJob.perform_bulk(settings.pluck(:id).zip)
        end
      end
    end
  end
end
