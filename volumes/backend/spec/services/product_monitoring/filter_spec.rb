require "rails_helper"

RSpec.describe ProductMonitoring::Filter do
  def reasons(name, **params)
    described_class.call(item: { name:, price: 100 }, params:)
  end

  it "matches required keywords regardless of case, width and spaces" do
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

  it "matches exclude keywords with the same normalization" do
    expect(reasons("iPhone ＣＡＳＥ", exclude_keywords: ["case"])).to eq(["excluded_keyword"])
    expect(reasons("iPhone 15 ProMax", exclude_keywords: ["Pro Max"])).to eq(["excluded_keyword"])
  end

  it "ignores keywords that are empty after normalization" do
    expect(reasons("Tablet", required_keywords: ["　"])).to be_empty
  end

  it "rejects names without the required keyword" do
    expect(reasons("Tablet", required_keywords: ["iPhone"])).to eq(["missing_required_keyword"])
  end
end
