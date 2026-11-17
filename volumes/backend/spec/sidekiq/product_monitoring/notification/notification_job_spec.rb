require "rails_helper"

RSpec.describe ProductMonitoring::Notification::NotificationJob do
  it "存在する設定の最安値通知と新着通知を評価する" do
    setting = ProductMonitoring::Monitor.create!(name: "監視", enabled: true)
    allow(ProductMonitoring::Notification::LowestPriceNotifier).to receive(:call)
    allow(ProductMonitoring::Notification::NewestNotifier).to receive(:call)

    described_class.new.perform(setting.id)

    expect(ProductMonitoring::Notification::LowestPriceNotifier).to have_received(:call)
      .with(monitor: setting)
    expect(ProductMonitoring::Notification::NewestNotifier).to have_received(:call)
      .with(monitor: setting)
  end

  it "削除された設定は評価しない" do
    allow(ProductMonitoring::Notification::LowestPriceNotifier).to receive(:call)

    described_class.new.perform(-1)

    expect(ProductMonitoring::Notification::LowestPriceNotifier).not_to have_received(:call)
  end

  it "予期しない例外をSidekiqに伝播する" do
    setting = ProductMonitoring::Monitor.create!(name: "監視", enabled: true)
    allow(ProductMonitoring::Notification::LowestPriceNotifier).to receive(:call).and_raise(StandardError, "failure")

    expect { described_class.new.perform(setting.id) }.to raise_error(StandardError, "failure")
  end
end
