require "rails_helper"

RSpec.describe ProductCrawlSettings::EnqueueSyncJob do
  it "enqueues only enabled settings" do
    enabled = create(:product_crawl_setting)
    create(:product_crawl_setting, enabled: false)
    allow(ProductCrawlSettings::SyncJob).to receive(:perform_bulk)

    described_class.new.perform

    expect(ProductCrawlSettings::SyncJob).to have_received(:perform_bulk).with([[enabled.id]])
  end
end
