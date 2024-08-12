require "rails_helper"

RSpec.describe JanparaCrawlSettingExcludeProduct, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:janpara_crawl_setting) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
