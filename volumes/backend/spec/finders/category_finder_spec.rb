require "rails_helper"

RSpec.describe CategoryFinder, type: :finder do
  let!(:root_category) { create(:category, name: "Root Category") }
  let!(:child_category) { root_category.children.create!(name: "Child Category") }

  describe "#execute" do
    it "フィルターが適用されていない場合、すべてのカテゴリを返すこと" do
      finder = described_class.new(params: {})
      expect(finder.execute).to contain_exactly(root_category, child_category)
    end

    it "root_onlyがtrueの場合、ルートカテゴリでフィルターして返すこと" do
      finder = described_class.new(params: { root_only: true })
      expect(finder.execute).to contain_exactly(root_category)
    end

    it "root_onlyがfalseの場合、ルートカテゴリでフィルターせずに返すこと" do
      finder = described_class.new(params: { root_only: false })
      expect(finder.execute).to contain_exactly(root_category, child_category)
    end

    it "nameでフィルターできること" do
      finder = described_class.new(params: { name: "Root Category" })
      expect(finder.execute).to contain_exactly(root_category)
    end
  end
end
