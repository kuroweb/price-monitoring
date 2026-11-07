require "rails_helper"

RSpec.describe ProductMonitoring::Sites::BrowserPage do
  it "許可されたホストの HTTPS URL を受け入れる" do
    page = instance_double(Playwright::Page, url: "https://jp.mercari.com/search?keyword=phone")
    expect { described_class.validate_url(page, host: "jp.mercari.com") }.not_to raise_error
  end

  it "異なるホスト、スキーム、ポート、認証情報を拒否する" do
    [
      "https://example.com/search",
      "http://jp.mercari.com/search",
      "https://jp.mercari.com:8443/search",
      "https://user@jp.mercari.com/search"
    ].each do |url|
      page = instance_double(Playwright::Page, url: url)
      expect { described_class.validate_url(page, host: "jp.mercari.com") }.to raise_error(/Unexpected page URL/)
    end
  end
end
