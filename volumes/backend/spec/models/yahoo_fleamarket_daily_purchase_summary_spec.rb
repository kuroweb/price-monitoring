require "rails_helper"

RSpec.describe YahooFleamarketDailyPurchaseSummary, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:product) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:purchase_count) }
    it { is_expected.to validate_presence_of(:date) }
  end
end
