require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::EnqueueSyncJob do
  let(:mercari) { ProductMonitoring::Crawling::Mercari::Listing::SyncJob }
  let(:iosys) { ProductMonitoring::Crawling::Iosys::Listing::SyncJob }

  before do
    ProductMonitoring::Crawling::UrlRouter::PLATFORMS.each { |platform| allow(platform::Listing::SyncJob).to receive(:perform_async) }
  end

  it "有効な設定ごとに、検索語のサイトと検索結果URLのサイトの一覧ジョブを積むこと" do
    enabled = create(:product_crawl_setting, keyword: "phone", platforms: ["mercari"],
                                             search_urls: ["https://iosys.co.jp/items?q=phone"])
    disabled = create(:product_crawl_setting, enabled: false, search_urls: ["https://iosys.co.jp/items?q=x"])

    described_class.new.perform

    expect(mercari).to have_received(:perform_async).with(enabled.id)
    expect(iosys).to have_received(:perform_async).with(enabled.id)
    expect(iosys).not_to have_received(:perform_async).with(disabled.id)
    expect(ProductMonitoring::Crawling::Janpara::Listing::SyncJob).not_to have_received(:perform_async)
  end

  it "URL が不正な設定があっても、ほかの設定の一覧ジョブを積むこと" do
    invalid = create(:product_crawl_setting)
    invalid.update_column(:search_urls, ["https://example.com/search?q=x"]) # rubocop:disable Rails/SkipsModelValidations
    valid = create(:product_crawl_setting, search_urls: ["https://iosys.co.jp/items?q=phone"])
    allow(Rails.logger).to receive(:error)

    described_class.new.perform

    expect(iosys).to have_received(:perform_async).with(valid.id)
    expect(Rails.logger).to have_received(:error).with(/#{invalid.id} has an invalid URL/)
  end
end
