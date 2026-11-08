require "rails_helper"

RSpec.describe IosysCrawlSettingExcludeProduct, type: :model do
  describe "関連付け" do
    it { is_expected.to belong_to(:iosys_crawl_setting) }
  end

  describe "バリデーション" do
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
