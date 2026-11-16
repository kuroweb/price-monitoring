require "rails_helper"

RSpec.describe ProductMonitoring::WatchSettings::Matcher do
  def matches?(name, price: 100, **condition)
    setting = ProductWatchSetting.new(name: "phone", **condition)
    described_class.call(product_watch_setting: setting, listing: { name:, price: })
  end

  describe ".call" do
    it "必須語は大文字小文字・全角半角・空白の有無を区別せずに判定すること" do
      ["IPHONE 15", "ｉＰｈｏｎｅ 15", "ＩＰＨＯＮＥ 15"].each do |name|
        expect(matches?(name, required_keywords: ["iPhone"])).to be true
      end
      expect(matches?("ｱｲﾌｫﾝ 15", required_keywords: ["アイフォン"])).to be true
      ["iPadPro 11", "iPad　Pro 11"].each { |name| expect(matches?(name, required_keywords: ["iPad Pro"])).to be true }
      expect(matches?("Tablet", required_keywords: ["iPhone"])).to be false
    end

    it "除外語も同じ正規化で判定し、どれか1つを含めば一致しないこと" do
      expect(matches?("iPhone ＣＡＳＥ", exclude_keywords: ["case"])).to be false
      expect(matches?("iPhone 15 ProMax", exclude_keywords: ["mini", "Pro Max"])).to be false
    end

    it "正規化すると空になる語は無視すること" do
      expect(matches?("Tablet", required_keywords: ["　"])).to be true
    end

    it "価格帯は上下限を含め、価格帯があるときは価格のない出品を一致させないこと" do
      expect(matches?("x", min_price: 100, max_price: 100)).to be true
      expect(matches?("x", price: 99, min_price: 100)).to be false
      expect(matches?("x", price: 101, max_price: 100)).to be false
      expect(matches?("x", price: nil, min_price: 100)).to be false
    end

    it "商品計測結果のレコードも判定できること" do
      result = build(:product_crawl_result, name: "iPhone 15", price: 100)
      setting = ProductWatchSetting.new(name: "phone", required_keywords: ["iphone"])
      expect(described_class.call(product_watch_setting: setting, listing: result)).to be true
    end
  end
end
