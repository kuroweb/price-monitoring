require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::DetailPage::SyncJob do
  let!(:yahoo) do
    create(:product_monitoring_crawl_result, platform: "yahoo_fleamarket", external_id: "z123", sold: false)
  end
  let!(:mercari) { create(:product_monitoring_crawl_result, platform: "mercari", external_id: "z123", sold: false) }

  it "Yahoo!フリマの出品だけを詳細で更新すること" do
    allow(ProductMonitoring::Crawling::YahooFleamarket::DetailPage::Crawler).to receive(:call).with(external_id: "z123")
                                                                                              .and_return(sold: true)
    described_class.new.perform("z123")
    expect(yahoo.reload.sold).to be true
    expect(mercari.reload.sold).to be false
  end

  it "再試行を使い切った後は Yahoo!フリマの出品の更新日時だけを進めること" do
    [yahoo, mercari].each { |result| result.update!(updated_at: 1.day.ago) }
    described_class.sidekiq_retries_exhausted_block.call({ "args" => ["z123"] }, StandardError.new)
    expect(yahoo.reload.updated_at).to be > 1.hour.ago
    expect(mercari.reload.updated_at).to be < 1.hour.ago
  end

  it "詳細で不存在と判定した出品を全収集設定から削除し、同じIDの別サイトの行は保持すること" do
    other_setting = create(:product_monitoring_crawl_setting)
    second = create(:product_monitoring_crawl_result, crawl_setting: other_setting, platform: "yahoo_fleamarket",
                                                      external_id: "z123", sold: true, sold_at: 2.days.ago)
    allow(ProductMonitoring::Crawling::YahooFleamarket::DetailPage::Crawler).to receive(:call)
      .with(external_id: "z123").and_return(deleted: true)

    described_class.new.perform("z123")

    expect(ProductMonitoring::CrawlResult.where(id: [yahoo.id, second.id])).to be_empty
    expect(mercari.reload.sold).to be false
  end
end
