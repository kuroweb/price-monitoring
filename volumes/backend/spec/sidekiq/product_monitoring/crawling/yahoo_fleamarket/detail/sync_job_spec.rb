require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::YahooFleamarket::Detail::SyncJob do
  let!(:yahoo) { create(:product_crawl_result, platform: "yahoo_fleamarket", external_id: "z123", sold: false) }
  let!(:mercari) { create(:product_crawl_result, platform: "mercari", external_id: "z123", sold: false) }

  it "Yahoo!フリマの出品だけを詳細で更新すること" do
    allow(ProductMonitoring::Crawling::YahooFleamarket::Detail::Crawler).to receive(:call).with(external_id: "z123")
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
end
