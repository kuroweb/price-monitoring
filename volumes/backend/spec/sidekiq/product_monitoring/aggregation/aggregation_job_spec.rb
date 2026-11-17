require "rails_helper"

RSpec.describe ProductMonitoring::Aggregation::AggregationJob do
  let(:setting) { create(:product_monitoring_monitor) }

  before { allow(ProductMonitoring::Aggregation::AggregateDailyMarketPrices).to receive(:call) }

  it "今日を含む直近 30 日を集計すること" do
    described_class.new.perform(setting.id)

    expect(ProductMonitoring::Aggregation::AggregateDailyMarketPrices).to have_received(:call).with(
      monitor: setting,
      start_date: Time.zone.today - 29,
      end_date: Time.zone.today
    )
  end

  it "削除された設定をスキップすること" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)

    expect(ProductMonitoring::Aggregation::AggregateDailyMarketPrices).not_to have_received(:call)
  end
end
