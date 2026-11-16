require "rails_helper"

RSpec.describe ProductMonitoring::CrawlSettings::Writer do
  let(:setting) { ProductCrawlSetting.new }

  def write(**params)
    described_class.call(product_crawl_setting: setting, params: { name: "phone", **params })
  end

  it "語句と検索結果URLを正規化し、有効状態を真偽値にして保存すること" do
    write(required_keywords: [" phone ", "phone", ""], search_urls: [" https://iosys.co.jp/items?q=x ", ""],
          enabled: "true")
    expect(setting.reload).to have_attributes(required_keywords: ["phone"], search_urls: ["https://iosys.co.jp/items?q=x"],
                                              enabled: true)
  end

  it "不正な行、真偽値、重複、過大な設定を拒否すること" do
    url = "https://iosys.co.jp/items?q=x"
    [
      { search_urls: [{ url: }] },
      { search_urls: Array.new(6) { |i| "https://iosys.co.jp/items?q=#{i}" } },
      { search_urls: [url] * 2 },
      { search_urls: [url], enabled: "maybe" },
      { search_urls: [url], required_keywords: ["x"] * 51 },
      { search_urls: [url], min_price: 1.5 }
    ].each do |params|
      expect { write(**params) }.to raise_error(ArgumentError)
    end
    expect(setting).not_to be_persisted
  end

  it "名前と、検索語とサイトまたは検索結果URLを必須にすること" do
    expect { write(name: "", search_urls: ["https://iosys.co.jp/items?q=x"]) }.to raise_error(ArgumentError, /名前/)
    expect { write }.to raise_error(ArgumentError, /1件以上/)
  end
end
