require "rails_helper"

RSpec.describe ProductMonitoring::EnqueueCrawlJobsJob do
  it "有効な設定だけを投入する" do
    enabled = create(:product_crawl_setting)
    create(:product_crawl_setting, enabled: false)
    allow(ProductMonitoring::CrawlJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductMonitoring::CrawlJob).to have_received(:perform_bulk).with([[enabled.id]])
  end
end
