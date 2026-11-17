require "rails_helper"

RSpec.describe ProductMonitoring::Notification::EnqueueNotificationJob do
  it "最安値通知か新着通知が有効な設定ごとに評価ジョブを投入する" do
    enabled = ProductMonitoring::Monitor.create!(name: "有効", enabled: true)
    newest = ProductMonitoring::Monitor.create!(name: "新着", newest_notification_enabled: true)
    ProductMonitoring::Monitor.create!(name: "無効", enabled: false)
    allow(ProductMonitoring::Notification::NotificationJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::Notification::NotificationJob).to have_received(:perform_bulk)
      .with([[enabled.id], [newest.id]])
  end
end
