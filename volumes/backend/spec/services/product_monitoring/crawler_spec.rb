require "rails_helper"

RSpec.describe ProductMonitoring::Crawler do
  it "deduplicates by external_id and applies common inclusive filters" do
    allow(described_class).to receive(:fetch).and_return([
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "one" },
                                                           { external_id: "a", name: "Phone blue", price: 100,
                                                             product_url: "two" }
                                                         ])
    result = described_class.call(params: {
                                    search_urls: ["https://jp.mercari.com/search?q=x",
                                                  "https://jp.mercari.com/search?q=y"], min_price: "100", max_price: "100", required_keywords: ["phone"]
                                  })
    expect(result[:fetched_count]).to eq(1)
    expect(result[:accepted_count]).to eq(1)
  end

  it "rejects malformed ranges" do
    expect { described_class.call(params: { min_price: "x", search_urls: [] }) }.to raise_error(ArgumentError, /価格/)
  end

  it "keeps source failures independent and reports unsupported URLs" do
    allow(described_class).to receive(:fetch) do |target|
      raise Timeout::Error if target[:platform] == "mercari"

      []
    end
    result = described_class.call(params: { search_urls: [
                                    "https://jp.mercari.com/search?q=bad",
                                    "https://example.com/search?q=x",
                                    "https://iosys.co.jp/items?q=ok"
                                  ] })
    expect(result[:sources].map { |source| source[:status] }).to eq(%w[failed unsupported succeeded])
  end

  it "logs the failure without the URL query and keeps the public error unchanged" do
    allow(described_class).to receive(:fetch).and_raise(Timeout::Error, "timed out")
    allow(Rails.logger).to receive(:warn)
    result = described_class.call(params: { search_urls: ["https://jp.mercari.com/search?q=secret"] })
    expect(Rails.logger).to have_received(:warn).with("Crawl failed for https://jp.mercari.com/search: Timeout::Error: timed out")
    expect(result[:sources].first[:error]).to eq("Crawl failed")
  end

  it "uses AND required words, OR excluded words, and listing exclusion" do
    allow(described_class).to receive(:fetch).and_return([
                                                           { external_id: "same", name: "Phone blue", price: 50,
                                                             product_url: "item" },
                                                           { external_id: "other", name: "Phone red", price: 50,
                                                             product_url: "item" },
                                                           { external_id: "excluded", name: "Phone blue", price: 50,
                                                             product_url: "item" }
                                                         ])
    result = described_class.call(params: {
                                    search_urls: ["https://jp.mercari.com/search?q=x"],
                                    required_keywords: %w[phone blue], exclude_keywords: ["red"],
                                    exclude_external_ids: ["excluded"]
                                  })
    expect(result[:results].map { |row| row[:accepted] }).to eq([true, false, false])
    expect(result[:results].second[:reasons]).to include("missing_required_keyword", "excluded_keyword")
    expect(result[:results].last[:reasons]).to eq(["excluded_listing"])
  end

  it "does not treat malformed keyword parameters as empty filters" do
    expect do
      described_class.call(params: { required_keywords: "phone", search_urls: [] })
    end.to raise_error(ArgumentError)
  end
end
