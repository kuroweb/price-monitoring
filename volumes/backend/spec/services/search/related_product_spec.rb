require "rails_helper"

RSpec.describe Search::RelatedProduct, type: :model do
  describe "#call" do
    let!(:product) do
      create(:product) do |product|
        create(:yahoo_auction_crawl_setting, product:, max_price: 20_000)
      end
    end

    context "platform_maskでのフィルタリングをテストする" do
      let!(:yahoo_auction_product_published) do
        create(:yahoo_auction_product, product:, name: "published", published: true,
                                       end_date: Time.current.since(7.days))
      end
      let!(:yahoo_auction_product_unpublished) do
        create(:yahoo_auction_product, product:, name: "unpublished", published: false,
                                       end_date: Time.current.ago(1.day))
      end
      let!(:yahoo_auction_product_buyable_a) do
        create(:yahoo_auction_product, product:, name: "buyable A", published: true,
                                       end_date: Time.current.since(7.days), buyout_price: 10_000)
      end
      let!(:yahoo_auction_product_buyable_b) do
        create(:yahoo_auction_product, product:, name: "buyable B", published: true,
                                       end_date: Time.current.since(23.hours), buyout_price: nil)
      end

      shared_examples "yahoo_auction.*でのフィルタリング" do |description|
        it description do
          service = described_class.new(params: { product_id: product.id, platform_mask:,
                                                  sort: "created_at", order: "asc" })
          actual_array = service.call.products

          expected_array = expected_products.map do |product|
            product
              .attributes
              .slice(*RelatedProduct.attribute_names)
              .merge("platform" => "yahoo_auction")
          end

          expected_array.each_with_index do |expected, index|
            expect(actual_array[index]).to have_attributes(expected)
          end
        end
      end

      context "yahoo_auction.allの場合" do
        let(:platform_mask) { "yahoo_auction.all" }
        let(:expected_products) do
          [
            yahoo_auction_product_published,
            yahoo_auction_product_unpublished,
            yahoo_auction_product_buyable_a,
            yahoo_auction_product_buyable_b
          ]
        end

        include_examples "yahoo_auction.*でのフィルタリング", "すべてのYahooAuctionProductの値を返却すること"
      end

      context "yahoo_auction.publishedの場合" do
        let(:platform_mask) { "yahoo_auction.published" }
        let(:expected_products) do
          [
            yahoo_auction_product_published,
            yahoo_auction_product_buyable_a,
            yahoo_auction_product_buyable_b
          ]
        end

        include_examples "yahoo_auction.*でのフィルタリング", "出品中のYahooAuctionProductの値を返却すること"
      end

      context "yahoo_auction.unpublishedの場合" do
        let(:platform_mask) { "yahoo_auction.unpublished" }
        let(:expected_products) do
          [yahoo_auction_product_unpublished]
        end

        include_examples "yahoo_auction.*でのフィルタリング", "出品終了済みのYahooAuctionProductの値を返却すること"
      end

      context "yahoo_auction.buyableの場合" do
        let(:platform_mask) { "yahoo_auction.buyable" }
        let(:expected_products) do
          [
            yahoo_auction_product_buyable_a,
            yahoo_auction_product_buyable_b
          ]
        end

        include_examples "yahoo_auction.*でのフィルタリング", "すぐに購入可能（即決価格がmax_price以下 OR 1日以内に終了）なYahooAuctionProductの値を返却すること"
      end
    end
  end
end
