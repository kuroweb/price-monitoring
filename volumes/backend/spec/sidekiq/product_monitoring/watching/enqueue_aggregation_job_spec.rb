require "rails_helper"

RSpec.describe ProductMonitoring::Watching::EnqueueAggregationJob do
  it "すべての設定を投入すること" do
    settings = create_list(:product_watch_setting, 2)
    allow(ProductMonitoring::Watching::AggregationJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::Watching::AggregationJob).to have_received(:perform_bulk)
      .with(settings.map { |setting| [setting.id] })
  end
end
