require "rails_helper"

RSpec.describe Categories::Updater, type: :service do
  describe ".call" do
    it "ルートカテゴリの名称更新時に親カテゴリが0にならずルートのままであること" do
      category = create(:category, name: "Before")

      described_class.call(
        category:,
        params: ActionController::Parameters.new(name: "After", parent_id: "0").permit(:name, :parent_id)
      )

      category.reload
      expect(category.name).to eq("After")
      expect(category.parent_id).to be_nil
      expect(Category.roots).to include(category)
    end
  end
end
