require "rails_helper"

RSpec.describe ProductMonitoring::Watching::NotificationJob do
  it "存在する設定を評価する" do
    setting = ProductWatchSetting.create!(name: "監視", enabled: true)
    allow(ProductMonitoring::Watching::LowestPriceNotifier).to receive(:call)

    described_class.new.perform(setting.id)

    expect(ProductMonitoring::Watching::LowestPriceNotifier).to have_received(:call)
      .with(product_watch_setting: setting)
  end

  it "削除された設定は評価しない" do
    allow(ProductMonitoring::Watching::LowestPriceNotifier).to receive(:call)

    described_class.new.perform(-1)

    expect(ProductMonitoring::Watching::LowestPriceNotifier).not_to have_received(:call)
  end

  it "予期しない例外をSidekiqに伝播する" do
    setting = ProductWatchSetting.create!(name: "監視", enabled: true)
    allow(ProductMonitoring::Watching::LowestPriceNotifier).to receive(:call).and_raise(StandardError, "failure")

    expect { described_class.new.perform(setting.id) }.to raise_error(StandardError, "failure")
  end
end
