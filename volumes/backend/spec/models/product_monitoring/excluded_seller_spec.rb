require "rails_helper"

RSpec.describe ProductMonitoring::ExcludedSeller do
  it "一覧から出品者IDを読む3サイトを対象にすること" do
    platforms = ProductMonitoring::Crawling::UrlRouter::PLATFORMS.map { |platform| platform::ListPage::SearchUrl::PLATFORM }
    expect(described_class::PLATFORMS).to contain_exactly("mercari", "yahoo_fleamarket", "yahoo_auction")
    expect(platforms).to include(*described_class::PLATFORMS)
  end

  it "同じサイトの同じ出品者IDは重ねて登録できず、大文字小文字が違えば別の出品者とすること" do
    described_class.create!(platform: "mercari", seller_id: "Seller_1")
    expect { described_class.create!(platform: "mercari", seller_id: "Seller_1") }
      .to raise_error(ActiveRecord::RecordNotUnique)
    expect(described_class.create!(platform: "mercari", seller_id: "seller_1")).to be_persisted
    expect(described_class.create!(platform: "yahoo_auction", seller_id: "Seller_1")).to be_persisted
  end
end
