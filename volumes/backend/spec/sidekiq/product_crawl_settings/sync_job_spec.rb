require "rails_helper"

RSpec.describe ProductCrawlSettings::SyncJob do
  let(:setting) { create(:product_crawl_setting) }

  before { allow(ProductCrawlSettings::SyncResults).to receive(:call) }

  it "syncs an enabled setting" do
    described_class.new.perform(setting.id)
    expect(ProductCrawlSettings::SyncResults).to have_received(:call).with(product_crawl_setting: setting)
  end

  it "skips a setting disabled after enqueue" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id)
    expect(ProductCrawlSettings::SyncResults).not_to have_received(:call)
  end

  it "skips a deleted setting" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)
    expect(ProductCrawlSettings::SyncResults).not_to have_received(:call)
  end
end
