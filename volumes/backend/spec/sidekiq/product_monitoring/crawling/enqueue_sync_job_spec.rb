require "rails_helper"

RSpec.describe ProductMonitoring::Crawling::EnqueueSyncJob do
  let(:mercari) { ProductMonitoring::Crawling::Mercari::ListPage::SyncJob }
  let(:iosys) { ProductMonitoring::Crawling::Iosys::ListPage::SyncJob }

  before do
    ProductMonitoring::Crawling::UrlRouter::PLATFORMS.each { |platform| allow(platform::ListPage::SyncJob).to receive(:perform_async) }
  end

  it "指定したサイトについて、有効な設定ごとに一覧ジョブを積むこと" do
    enabled = create(:product_monitoring_crawl_setting, search_keyword: "phone", platforms: ["mercari"],
                                                        search_urls: ["https://iosys.co.jp/items?q=phone"])
    disabled = create(:product_monitoring_crawl_setting, enabled: false, search_urls: ["https://iosys.co.jp/items?q=x"])

    described_class.new.perform("iosys")

    expect(iosys).to have_received(:perform_async).with(enabled.id)
    expect(iosys).not_to have_received(:perform_async).with(disabled.id)
    expect(mercari).not_to have_received(:perform_async)
  end

  it "検索ワードのサイトも、指定したサイトなら一覧ジョブを積むこと" do
    crawl_setting = create(:product_monitoring_crawl_setting, search_keyword: "phone", platforms: ["mercari"])

    described_class.new.perform("mercari")

    expect(mercari).to have_received(:perform_async).with(crawl_setting.id)
  end

  it "指定したサイトを含まない設定の一覧ジョブは積まないこと" do
    create(:product_monitoring_crawl_setting, search_urls: ["https://iosys.co.jp/items?q=phone"])

    described_class.new.perform("janpara")

    ProductMonitoring::Crawling::UrlRouter::PLATFORMS.each do |platform|
      expect(platform::ListPage::SyncJob).not_to have_received(:perform_async)
    end
  end

  it "URL が不正な設定があっても、ほかの設定の一覧ジョブを積むこと" do
    invalid = create(:product_monitoring_crawl_setting)
    invalid.update_column(:search_urls, ["https://example.com/search?q=x"]) # rubocop:disable Rails/SkipsModelValidations
    valid = create(:product_monitoring_crawl_setting, search_urls: ["https://iosys.co.jp/items?q=phone"])
    allow(Rails.logger).to receive(:error)

    described_class.new.perform("iosys")

    expect(iosys).to have_received(:perform_async).with(valid.id)
    expect(Rails.logger).to have_received(:error).with(/#{invalid.id} has an invalid URL/)
  end

  it "対応しないサイトを指定したら失敗すること" do
    expect { described_class.new.perform("unknown") }.to raise_error(ArgumentError, /unknown is unsupported/)
  end

  it "定期取得のスケジュールに、すべてのサイトが1つずつ登録されていること" do
    schedule = YAML.load_file(Rails.root.join("config/schedule.yml"))
    scheduled = schedule.values.select { |job| job["class"] == described_class.name }.pluck("args")

    expected = ProductMonitoring::Crawling::UrlRouter::PLATFORMS.map { |platform| [platform::ListPage::SearchUrl::PLATFORM] }
    expect(scheduled).to match_array(expected)
  end
end
