require "rails_helper"

RSpec.describe ProductMonitoring::EvaluateWatchSettingsJob do
  it "有効な設定ごとに評価ジョブを投入する" do
    enabled = ProductWatchSetting.create!(name: "有効", enabled: true)
    ProductWatchSetting.create!(name: "無効", enabled: false)
    allow(ProductMonitoring::EvaluateWatchSettingJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::EvaluateWatchSettingJob).to have_received(:perform_bulk).with([[enabled.id]])
  end
end
