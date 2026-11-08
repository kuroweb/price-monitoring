require "rails_helper"

RSpec.describe ProductMonitoring::EvaluateWatchSettingJob do
  it "存在する設定を評価する" do
    setting = ProductWatchSetting.create!(name: "監視", enabled: true)
    allow(ProductMonitoring::LowestPriceNotifier).to receive(:call)

    described_class.new.perform(setting.id)

    expect(ProductMonitoring::LowestPriceNotifier).to have_received(:call).with(product_watch_setting: setting)
  end

  it "削除された設定は評価しない" do
    allow(ProductMonitoring::LowestPriceNotifier).to receive(:call)

    described_class.new.perform(-1)

    expect(ProductMonitoring::LowestPriceNotifier).not_to have_received(:call)
  end
end
