require "rails_helper"

RSpec.describe ProductAggregationSettings::CalculateResultsJob do
  let(:setting) { create(:product_aggregation_setting) }

  before { allow(ProductAggregationSettings::CalculateResults).to receive(:call) }

  it "calculates the last 30 days including today" do
    described_class.new.perform(setting.id)

    expect(ProductAggregationSettings::CalculateResults).to have_received(:call).with(
      product_aggregation_setting: setting,
      start_date: Time.zone.today - 29,
      end_date: Time.zone.today
    )
  end

  it "skips a deleted setting" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)

    expect(ProductAggregationSettings::CalculateResults).not_to have_received(:call)
  end
end
