require "rails_helper"

RSpec.describe YahooAuctionCrawlSettingExcludeProduct, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:yahoo_auction_crawl_setting) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
