require "rails_helper"

RSpec.describe ProductMonitoring::Filter do
  def reasons(name, **params)
    described_class.call(item: { name:, price: 100 }, params:)
  end

  it "必須語は大文字小文字・全角半角・空白の有無を区別せずに判定する" do
    ["IPHONE 15", "ｉＰｈｏｎｅ 15", "ＩＰＨＯＮＥ 15"].each do |name|
      expect(reasons(name, required_keywords: ["iPhone"])).to be_empty
    end
    expect(reasons("iPhone 15", required_keywords: ["ｉＰｈｏｎｅ"])).to be_empty
    expect(reasons("ｱｲﾌｫﾝ 15", required_keywords: ["アイフォン"])).to be_empty
    ["iPadPro 11", "iPad　Pro 11"].each do |name|
      expect(reasons(name, required_keywords: ["iPad Pro"])).to be_empty
    end
    expect(reasons("iPad mini AppleCare+", required_keywords: ["Apple Care"])).to be_empty
  end

  it "除外語も同じ正規化で判定する" do
    expect(reasons("iPhone ＣＡＳＥ", exclude_keywords: ["case"])).to eq(["excluded_keyword"])
    expect(reasons("iPhone 15 ProMax", exclude_keywords: ["Pro Max"])).to eq(["excluded_keyword"])
  end

  it "正規化すると空になる語は無視する" do
    expect(reasons("Tablet", required_keywords: ["　"])).to be_empty
  end

  it "必須語を含まない名前は除外する" do
    expect(reasons("Tablet", required_keywords: ["iPhone"])).to eq(["missing_required_keyword"])
  end
end
