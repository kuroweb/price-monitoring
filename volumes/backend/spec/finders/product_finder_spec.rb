require "rails_helper"

RSpec.describe ProductFinder, type: :finder do
  let!(:product_a) { create(:product, name: "Product A", created_at: 3.days.ago, updated_at: 3.days.ago) }
  let!(:product_b) { create(:product, name: "Product B", created_at: 2.days.ago, updated_at: 2.days.ago) }
  let!(:product_c) { create(:product, name: "Product C", created_at: 1.day.ago, updated_at: 1.day.ago) }

  describe "#execute" do
    it "フィルターが適用されていない場合、すべての商品を返すこと" do
      finder = described_class.new(params: {})
      expect(finder.execute).to contain_exactly(product_a, product_b, product_c)
    end

    it "idでフィルターできること" do
      finder = described_class.new(params: { id: product_a.id })
      expect(finder.execute).to contain_exactly(product_a)
    end

    it "nameでフィルターできること" do
      finder = described_class.new(params: { name: "Product A" })
      expect(finder.execute).to contain_exactly(product_a)
    end

    it "created_atで降順ソートできること" do
      finder = described_class.new(params: { sort: "created_at", order: "desc" })
      expect(finder.execute).to eq([product_c, product_b, product_a])
    end

    it "created_atで昇順ソートできること" do
      finder = described_class.new(params: { sort: "created_at", order: "asc" })
      expect(finder.execute).to eq([product_a, product_b, product_c])
    end

    it "updated_atで降順ソートできること" do
      finder = described_class.new(params: { sort: "updated_at", order: "desc" })
      expect(finder.execute).to eq([product_c, product_b, product_a])
    end

    it "updated_atで昇順ソートできること" do
      finder = described_class.new(params: { sort: "updated_at", order: "asc" })
      expect(finder.execute).to eq([product_a, product_b, product_c])
    end

    it "無効なソートまたは順序が指定された場合、デフォルトの順序で商品を返すこと" do
      finder = described_class.new(params: { sort: "invalid_column", order: "invalid_order" })
      expect(finder.execute).to eq([product_a, product_b, product_c])
    end
  end
end
