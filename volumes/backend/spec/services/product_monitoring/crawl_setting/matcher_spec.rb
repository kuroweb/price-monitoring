require "rails_helper"

RSpec.describe ProductMonitoring::CrawlSetting::Matcher do
  def matches?(name, price: 100, **condition)
    described_class.call(crawl_setting: build(:product_monitoring_crawl_setting, **condition),
                         listing: { name:, price: })
  end

  describe ".call" do
    it "必須語は大文字小文字・全角半角・空白の有無を区別せずに判定すること" do
      ["IPHONE 15", "ｉＰｈｏｎｅ 15", "ＩＰＨＯＮＥ 15"].each do |name|
        expect(matches?(name, required_keywords: ["iPhone"])).to be true
      end
      expect(matches?("iPhone 15", required_keywords: ["ｉＰｈｏｎｅ"])).to be true
      expect(matches?("ｱｲﾌｫﾝ 15", required_keywords: ["アイフォン"])).to be true
      ["iPadPro 11", "iPad　Pro 11"].each { |name| expect(matches?(name, required_keywords: ["iPad Pro"])).to be true }
      expect(matches?("iPad mini AppleCare+", required_keywords: ["Apple Care"])).to be true
      expect(matches?("Tablet", required_keywords: ["iPhone"])).to be false
    end

    it "除外語も同じ正規化で判定し、どれか1つを含めば一致しないこと" do
      expect(matches?("iPhone ＣＡＳＥ", negative_keywords: ["case"])).to be false
      expect(matches?("iPhone 15 ProMax", negative_keywords: ["mini", "Pro Max"])).to be false
    end

    it "正規化すると空になる語は無視すること" do
      expect(matches?("Tablet", required_keywords: ["　"])).to be true
    end

    it "価格帯は上下限を含め、価格帯があるときは価格のない出品を一致させないこと" do
      expect(matches?("x", min_price: 100, max_price: 100)).to be true
      expect(matches?("x", price: 99, min_price: 100)).to be false
      expect(matches?("x", price: 101, max_price: 100)).to be false
      expect(matches?("x", price: nil, min_price: 100)).to be false
      expect(matches?("x", price: nil)).to be true
    end

    it "収集結果のレコードも判定できること" do
      result = build(:product_monitoring_crawl_result, name: "iPhone 15", price: 100)
      setting = build(:product_monitoring_crawl_setting, required_keywords: ["iphone"], max_price: 100)
      expect(described_class.call(crawl_setting: setting, listing: result)).to be true
    end
  end
end
