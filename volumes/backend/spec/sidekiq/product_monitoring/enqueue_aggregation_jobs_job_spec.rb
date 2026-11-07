require "rails_helper"

RSpec.describe ProductMonitoring::EnqueueAggregationJobsJob do
  it "enqueues every setting" do
    settings = create_list(:product_aggregation_setting, 2)
    allow(ProductMonitoring::AggregationJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::AggregationJob).to have_received(:perform_bulk)
      .with(settings.map { |setting| [setting.id] })
  end
end
