require "rails_helper"

RSpec.describe ProductAggregationSettings::EnqueueCalculateResultsJob do
  it "enqueues every setting" do
    settings = create_list(:product_aggregation_setting, 2)
    allow(ProductAggregationSettings::CalculateResultsJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductAggregationSettings::CalculateResultsJob).to have_received(:perform_bulk)
      .with(settings.map { |setting| [setting.id] })
  end
end
