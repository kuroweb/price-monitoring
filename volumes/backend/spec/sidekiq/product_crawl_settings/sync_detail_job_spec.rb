require "rails_helper"

RSpec.describe ProductCrawlSettings::SyncDetailJob do
  let!(:first) { create(:product_crawl_result, platform: "mercari", external_id: "m123", sold: false) }
  let!(:second) { create(:product_crawl_result, platform: "mercari", external_id: "m123", sold: false) }

  it "updates all matching rows and preserves an existing bought date" do
    date = 2.days.ago.beginning_of_day
    first.update!(bought_date: date)
    allow(ProductMonitoring::Sites::Mercari).to receive(:fetch_detail)
      .with("m123").and_return(sold: true, bought_date: Time.current.beginning_of_day)
    described_class.new.perform("m123")
    expect(first.reload).to have_attributes(sold: true, bought_date: date)
    expect(second.reload).to have_attributes(sold: true, bought_date: Time.current.beginning_of_day)
    expect(ProductMonitoring::Sites::Mercari).to have_received(:fetch_detail).once
  end

  it "sets available listings to false" do
    first.update!(sold: true)
    allow(ProductMonitoring::Sites::Mercari).to receive(:fetch_detail).and_return(sold: false)
    described_class.new.perform("m123")
    expect(first.reload.sold).to be false
  end

  it "deletes all rows for a deleted listing" do
    allow(ProductMonitoring::Sites::Mercari).to receive(:fetch_detail).and_return(deleted: true)
    described_class.new.perform("m123")
    expect(ProductCrawlResult.where(id: [first.id, second.id])).to be_empty
  end

  it "leaves an unknown result unchanged" do
    allow(ProductMonitoring::Sites::Mercari).to receive(:fetch_detail).and_return({})
    described_class.new.perform("m123")
    expect(first.reload.sold).to be false
  end
end
