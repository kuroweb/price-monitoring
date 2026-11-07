require "rails_helper"

RSpec.describe YahooAuctionCrawlSettingRequiredKeyword, type: :model do
  describe "関連付け" do
    it { is_expected.to belong_to(:yahoo_auction_crawl_setting) }
  end

  describe "バリデーション" do
    it { is_expected.to validate_presence_of(:keyword) }
  end
end
