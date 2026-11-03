require "rails_helper"

RSpec.describe Crawl::Search::Input do
  it "normalizes shared keywords and preserves platform scoped exclusions" do
    result = described_class.call(params: { required_keywords: [" phone ", "phone", ""], excluded_listings: [{ platform: "mercari", external_id: "x" }, { platform: "iosys", external_id: "x" }], urls: [{ url: "https://iosys.co.jp/items?q=x", enabled: "false" }] })
    expect(result[:required_keywords]).to eq(["phone"])
    expect(result[:excluded_listings].size).to eq(2)
    expect(result[:urls].first[:enabled]).to be(false)
  end

  it "rejects malformed rows, booleans and oversized configuration" do
    [{ urls: ["bad"] }, { urls: Array.new(6) { { url: "https://iosys.co.jp/items?q=x" } } }, { enabled: "maybe" }, { required_keywords: ["x"] * 51 }, { min_price: 1.5 }, { excluded_listings: [1] }].each do |params|
      expect { described_class.call(params: params) }.to raise_error(ArgumentError)
    end
  end
end
