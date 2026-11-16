require "rails_helper"

RSpec.describe ProductMonitoring::Watching::EnqueueNotificationJob do
  it "有効な設定ごとに評価ジョブを投入する" do
    enabled = ProductWatchSetting.create!(name: "有効", enabled: true)
    ProductWatchSetting.create!(name: "無効", enabled: false)
    allow(ProductMonitoring::Watching::NotificationJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::Watching::NotificationJob).to have_received(:perform_bulk).with([[enabled.id]])
  end
end
