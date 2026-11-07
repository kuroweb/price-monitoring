require "rails_helper"

RSpec.describe RelatedProducts, type: :model do
  describe "#add" do
    let!(:related_product_a) { RelatedProduct.new }
    let!(:related_product_b) { RelatedProduct.new }

    it "related_productを追加できること" do
      related_products = described_class.new([related_product_a])
      related_products.add(related_product_b)

      expect(related_products.products).to eq([related_product_a, related_product_b])
    end
  end

  describe "#valid?" do
    let!(:related_product_a) { RelatedProduct.new }
    let!(:related_product_b) { RelatedProduct.new }

    it "productsがすべてvalidな場合、trueを返却すること" do
      allow(related_product_a).to receive(:valid?).and_return(true)
      allow(related_product_b).to receive(:valid?).and_return(true)
      related_products = described_class.new([related_product_a, related_product_b])

      expect(related_products.valid?).to be(true)
    end

    it "productsにinvalidを含む場合、falseを返却すること" do
      allow(related_product_a).to receive(:valid?).and_return(true)
      allow(related_product_b).to receive(:valid?).and_return(false)
      related_products = described_class.new([related_product_a, related_product_b])

      expect(related_products.valid?).to be(false)
    end
  end

  describe "#errors" do
    xit "errorsのメッセージ出力は暫定実装なのでテストしない"
  end
end
