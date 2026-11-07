require "rails_helper"

RSpec.describe ProductMonitoring::CrawlJob do
  let(:setting) { create(:product_crawl_setting) }

  before { allow(ProductMonitoring::SyncCrawlResults).to receive(:call) }

  it "syncs an enabled setting" do
    described_class.new.perform(setting.id)
    expect(ProductMonitoring::SyncCrawlResults).to have_received(:call).with(product_crawl_setting: setting)
  end

  it "skips a setting disabled after enqueue" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id)
    expect(ProductMonitoring::SyncCrawlResults).not_to have_received(:call)
  end

  it "syncs a disabled setting when requested manually" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id, true)
    expect(ProductMonitoring::SyncCrawlResults).to have_received(:call).with(product_crawl_setting: setting)
  end

  it "skips a deleted setting" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)
    expect(ProductMonitoring::SyncCrawlResults).not_to have_received(:call)
  end
end
