require "rails_helper"

RSpec.describe MercariCrawlSetting, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:mercari_crawl_setting_exclude_keywords).dependent(:destroy) }
    it { is_expected.to have_many(:mercari_crawl_setting_exclude_products).dependent(:destroy) }
    it { is_expected.to have_many(:mercari_crawl_setting_required_keywords).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:keyword) }
  end
end
