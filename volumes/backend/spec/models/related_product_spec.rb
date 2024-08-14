require "rails_helper"

RSpec.describe RelatedProduct, type: :model do
  describe "validations" do
    it { is_expected.to allow_value(true).for(:published) }
    it { is_expected.to allow_value(false).for(:published) }
    it { is_expected.to validate_presence_of(:platform) }
    it { is_expected.to validate_presence_of(:product_id) }
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:thumbnail_url) }
    it { is_expected.to validate_presence_of(:created_at) }
    it { is_expected.to validate_presence_of(:updated_at) }
  end
end
