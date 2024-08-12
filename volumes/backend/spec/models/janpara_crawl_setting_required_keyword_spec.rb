require "rails_helper"

RSpec.describe JanparaCrawlSettingRequiredKeyword, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:janpara_crawl_setting) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:keyword) }
  end
end
