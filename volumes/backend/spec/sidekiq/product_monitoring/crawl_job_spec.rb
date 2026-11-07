require "rails_helper"

RSpec.describe ProductMonitoring::CrawlJob do
  let(:setting) { create(:product_crawl_setting) }

  before { allow(ProductMonitoring::SyncCrawlResults).to receive(:call) }

  it "有効な設定を同期すること" do
    described_class.new.perform(setting.id)
    expect(ProductMonitoring::SyncCrawlResults).to have_received(:call).with(product_crawl_setting: setting)
  end

  it "投入後に無効化された設定をスキップすること" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id)
    expect(ProductMonitoring::SyncCrawlResults).not_to have_received(:call)
  end

  it "手動で要求された場合は無効な設定を同期すること" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id, true)
    expect(ProductMonitoring::SyncCrawlResults).to have_received(:call).with(product_crawl_setting: setting)
  end

  it "削除された設定をスキップすること" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)
    expect(ProductMonitoring::SyncCrawlResults).not_to have_received(:call)
  end
end
