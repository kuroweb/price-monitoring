require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::DetailPage::Syncer do
  def stub_detail(detail)
    allow(ProductMonitoring::Crawling::Mercari::DetailPage::Crawler).to receive(:call)
      .with(external_id: "m1").and_return(detail)
  end

  it "売れた日を書いた行の並び時刻も売れた日にする" do
    sold_at = Time.zone.parse("2026-11-09 00:00:00")
    result = create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m1", sold: false,
                                                      recency_at: 3.days.ago)
    stub_detail(sold: true, sold_at:)

    described_class.call(external_id: "m1")

    expect(result.reload).to have_attributes(sold: true, sold_at:, recency_at: sold_at)
  end

  it "売れた日のない売り切れは並び時刻を空にする" do
    result = create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m1", sold: false,
                                                      recency_at: 3.days.ago)
    stub_detail(sold: true)

    described_class.call(external_id: "m1")

    expect(result.reload).to have_attributes(sold: true, sold_at: nil, recency_at: nil)
  end

  it "既に売れた日がある行は、詳細で売れた日が取れなくても並び時刻を売れた日のままにする" do
    sold_at = Time.zone.parse("2026-11-09 00:00:00")
    result = create(:product_monitoring_crawl_result, platform: "mercari", external_id: "m1", sold: true,
                                                      sold_at:, recency_at: sold_at)
    stub_detail(sold: true)

    described_class.call(external_id: "m1")

    expect(result.reload).to have_attributes(sold: true, sold_at:, recency_at: sold_at)
  end
end
