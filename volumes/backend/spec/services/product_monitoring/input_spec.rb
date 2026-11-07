require "rails_helper"

RSpec.describe ProductMonitoring::Input do
  it "キーワード、除外条件、検索 URL を正規化すること" do
    result = described_class.call(params: {
                                    required_keywords: [" phone ", "phone", ""],
                                    exclude_external_ids: %w[x x y],
                                    search_urls: [" https://iosys.co.jp/items?q=x ", ""],
                                    enabled: "true"
                                  })
    expect(result[:required_keywords]).to eq(["phone"])
    expect(result[:exclude_external_ids]).to eq(%w[x y])
    expect(result[:search_urls]).to eq(["https://iosys.co.jp/items?q=x"])
    expect(result[:enabled]).to be(true)
  end

  it "不正な行、真偽値、重複、過大な設定を拒否すること" do
    [
      { search_urls: [{ url: "https://iosys.co.jp/items?q=x" }] },
      { search_urls: Array.new(6) { |i| "https://iosys.co.jp/items?q=#{i}" } },
      { search_urls: ["https://iosys.co.jp/items?q=x"] * 2 },
      { enabled: "maybe" },
      { required_keywords: ["x"] * 51 },
      { min_price: 1.5 },
      { exclude_external_ids: [1] }
    ].each do |params|
      expect { described_class.call(params:) }.to raise_error(ArgumentError)
    end
  end

  it "要求された場合に限り名前と検索 URL を必須にすること" do
    expect { described_class.call(params: { name: "" }, require_name: true) }.to raise_error(ArgumentError, /名前/)
    expect do
      described_class.call(params: { name: "phone" }, require_name: true,
                           require_search_urls: true)
    end.to raise_error(ArgumentError, /1件以上/)
    expect(described_class.call(params: { name: "phone" }, require_name: true)[:name]).to eq("phone")
  end
end
