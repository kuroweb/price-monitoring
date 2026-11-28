require "rails_helper"

RSpec.describe ProductMonitoring::ExcludedSeller::Writer do
  def write(**params)
    described_class.call(params:)
  end

  it "前後の空白だけを除き、大文字小文字は変えずに登録すること" do
    expect(write(platform: "yahoo_fleamarket", seller_id: " Seller_1 "))
      .to have_attributes(platform: "yahoo_fleamarket", seller_id: "Seller_1")
  end

  it "対象外のサイトと形式の違う出品者IDは登録しないこと" do
    expect { write(platform: "iosys", seller_id: "a") }.to raise_error(ArgumentError, "サイトの指定が不正です")
    ["", "has space", "a/b", "ａ", "a" * 256, nil, 1, ["a"]].each do |seller_id|
      expect { write(platform: "mercari", seller_id:) }.to raise_error(ArgumentError, /\A出品者IDは/)
    end
    expect(ProductMonitoring::ExcludedSeller.count).to eq(0)
  end
end
