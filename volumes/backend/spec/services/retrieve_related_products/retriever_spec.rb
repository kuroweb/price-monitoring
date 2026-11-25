require "rails_helper"

RSpec.describe RetrieveRelatedProducts::Retriever, type: :service do
  describe "#call" do
    let!(:product) { create(:product) }

    it "旧計測のプラットフォーム指定では関連商品を返さないこと" do
      service = described_class.new(
        params: {
          product_id: product.id,
          platform_mask: "yahoo_auction.buyable",
          page: 1,
          per: 10,
          sort: "created_at",
          order: "asc"
        }
      )

      expect(service.call.products).to be_empty
    end
  end
end
