require "rails_helper"

RSpec.describe MercariCrawlSettingExcludeKeyword, type: :model do
  describe "関連付け" do
    it { is_expected.to belong_to(:mercari_crawl_setting) }
  end

  describe "バリデーション" do
    it { is_expected.to validate_presence_of(:keyword) }
  end
end
