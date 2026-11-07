require "rails_helper"

RSpec.describe ProductMonitoring::AggregationJob do
  let(:setting) { create(:product_aggregation_setting) }

  before { allow(ProductMonitoring::CalculateAggregationResults).to receive(:call) }

  it "今日を含む直近 30 日を集計する" do
    described_class.new.perform(setting.id)

    expect(ProductMonitoring::CalculateAggregationResults).to have_received(:call).with(
      product_aggregation_setting: setting,
      start_date: Time.zone.today - 29,
      end_date: Time.zone.today
    )
  end

  it "削除された設定をスキップする" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)

    expect(ProductMonitoring::CalculateAggregationResults).not_to have_received(:call)
  end
end
