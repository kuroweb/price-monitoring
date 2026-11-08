require "rails_helper"
require "closure_tree/test/matcher"

RSpec.describe Category, type: :model do
  describe "関連付け" do
    it { is_expected.to have_many(:product_category_maps).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:product_category_maps) }
    it { is_expected.to be_a_closure_tree }
  end

  describe "バリデーション" do
    context "組み込みバリデーションを検証するとき" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "深さの上限を検証するとき" do
      context "深さが 0 の場合" do
        let!(:depth_0_category) { build(:category) }

        it { expect(depth_0_category.valid?).to be(true) }
      end

      context "深さが 1 の場合" do
        let!(:depth_0_category) { create(:category) }
        let!(:depth_1_category) { depth_0_category.children.build(name: "depth 1") }

        it { expect(depth_1_category.valid?).to be(true) }
      end

      context "深さが 2 の場合" do
        let!(:depth_0_category) { create(:category) }
        let!(:depth_1_category) { depth_0_category.children.create!(name: "depth 1") }
        let!(:depth_2_category) { depth_1_category.children.build(name: "depth 2") }

        it { expect(depth_2_category.valid?).to be(true) }
      end

      context "深さが 3 の場合" do
        let!(:depth_0_category) { create(:category) }
        let!(:depth_1_category) { depth_0_category.children.create!(name: "depth 1") }
        let!(:depth_2_category) { depth_1_category.children.create!(name: "depth 2") }
        let!(:depth_3_category) { depth_2_category.children.build(name: "depth 3") }

        it { expect(depth_3_category.valid?).to be(true) }
      end
    end
  end
end
