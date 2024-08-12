require "rails_helper"

RSpec.describe UsedSofmapCrawlSettingExcludeProduct, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:used_sofmap_crawl_setting) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
