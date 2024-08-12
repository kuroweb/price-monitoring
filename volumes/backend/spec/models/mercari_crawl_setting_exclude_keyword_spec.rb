require "rails_helper"

RSpec.describe MercariCrawlSettingExcludeKeyword, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:mercari_crawl_setting) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:keyword) }
  end
end
