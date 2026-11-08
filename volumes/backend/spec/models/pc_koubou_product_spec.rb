require "rails_helper"

RSpec.describe PcKoubouProduct, type: :model do
  describe "関連付け" do
    it { is_expected.to belong_to(:product) }
  end

  describe "バリデーション" do
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:thumbnail_url) }
  end
end
