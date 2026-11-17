require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::Mercari::ListPage::SyncJob do
  let(:syncer) { ProductMonitoring::Crawling::Mercari::ListPage::Syncer }
  let(:setting) { create(:product_monitoring_crawl_setting) }

  before { allow(syncer).to receive(:call) }

  it "有効な設定をメルカリの一覧で同期すること" do
    described_class.new.perform(setting.id)
    expect(syncer).to have_received(:call).with(crawl_setting: setting)
  end

  it "無効な設定は手動のときだけ同期すること" do
    setting.update!(enabled: false)
    described_class.new.perform(setting.id)
    expect(syncer).not_to have_received(:call)
    described_class.new.perform(setting.id, true)
    expect(syncer).to have_received(:call).once
  end

  it "削除された設定をスキップすること" do
    id = setting.id
    setting.destroy!
    described_class.new.perform(id)
    expect(syncer).not_to have_received(:call)
  end
end
