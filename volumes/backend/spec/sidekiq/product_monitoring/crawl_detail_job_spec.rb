require "rails_helper"

RSpec.describe ProductMonitoring::CrawlDetailJob do
  let!(:second) { create(:product_crawl_result, platform: "mercari", external_id: "m123", sold: false) }
  let!(:first) { create(:product_crawl_result, platform: "mercari", external_id: "m123", sold: false) }

  it "updates only the requested platform for a Yahoo listing" do
    yahoo = create(:product_crawl_result, platform: "yahoo_fleamarket", external_id: "m123", sold: false)
    allow(ProductMonitoring::Sites::YahooFleamarket).to receive(:fetch_detail).and_return(sold: true)
    described_class.new.perform("m123", "yahoo_fleamarket")
    expect(yahoo.reload.sold).to be true
    expect(first.reload.sold).to be false
  end

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

  it "updates only the timestamps for an unknown result" do
    first.update!(updated_at: 1.day.ago, bought_date: 2.days.ago)
    previous = first.reload.attributes
    allow(ProductMonitoring::Sites::Mercari).to receive(:fetch_detail).and_return({})
    described_class.new.perform("m123")
    expect(first.reload.updated_at).to be > previous["updated_at"]
    expect(first.attributes.except("updated_at")).to eq(previous.except("updated_at"))
  end

  it "updates only the timestamps after retries are exhausted" do
    first.update!(updated_at: 1.day.ago, bought_date: 2.days.ago)
    previous = first.reload.attributes
    described_class.sidekiq_retries_exhausted_block.call({ "args" => ["m123"] }, StandardError.new)
    expect(first.reload.updated_at).to be > previous["updated_at"]
    expect(first.attributes.except("updated_at")).to eq(previous.except("updated_at"))
  end
end
