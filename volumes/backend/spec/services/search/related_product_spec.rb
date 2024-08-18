require "rails_helper"

RSpec.describe Search::RelatedProduct, type: :service do
  describe "#call" do
    let!(:product) { create(:product) }

    context "platform_maskでのフィルタリングをテストする" do
      context "yahoo_auctionを指定した場合" do
        before do
          create(:yahoo_auction_crawl_setting, product:, max_price: 20_000)
        end

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

        shared_examples "フィルタリングのテスト" do |description|
          it description do
            service = described_class.new(params: { product_id: product.id, platform_mask:,
                                                    sort: "created_at", order: "asc" })
            actual_array = service.call.products
            expected_array = expected_products.map do |product|
              product.attributes
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

          include_examples "フィルタリングのテスト", "すべてのYahooAuctionProductの値を返却すること"
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

          include_examples "フィルタリングのテスト", "出品中のYahooAuctionProductの値を返却すること"
        end

        context "yahoo_auction.unpublishedの場合" do
          let(:platform_mask) { "yahoo_auction.unpublished" }
          let(:expected_products) { [yahoo_auction_product_unpublished] }

          include_examples "フィルタリングのテスト", "出品終了済みのYahooAuctionProductの値を返却すること"
        end

        context "yahoo_auction.buyableの場合" do
          let(:platform_mask) { "yahoo_auction.buyable" }
          let(:expected_products) { [yahoo_auction_product_buyable_a, yahoo_auction_product_buyable_b] }

          include_examples "フィルタリングのテスト", "すぐに購入可能（即決価格がmax_price以下 OR 1日以内に終了）なYahooAuctionProductの値を返却すること"
        end
      end

      context "yahoo_fleamarketを指定した場合" do
        let!(:yahoo_fleamarket_product_published) do
          create(:yahoo_fleamarket_product, product:, name: "published", published: true)
        end
        let!(:yahoo_fleamarket_product_unpublished) do
          create(:yahoo_fleamarket_product, product:, name: "unpublished", published: false)
        end

        shared_examples "フィルタリングのテスト" do |description|
          it description do
            service = described_class.new(params: { product_id: product.id, platform_mask:,
                                                    sort: "created_at", order: "asc" })
            actual_array = service.call.products
            expected_array = expected_products.map do |product|
              product.attributes
                     .slice(*RelatedProduct.attribute_names)
                     .merge("platform" => "yahoo_fleamarket")
            end

            expected_array.each_with_index do |expected, index|
              expect(actual_array[index]).to have_attributes(expected)
            end
          end
        end

        context "yahoo_fleamarket.allの場合" do
          let(:platform_mask) { "yahoo_fleamarket.all" }
          let(:expected_products) { [yahoo_fleamarket_product_published, yahoo_fleamarket_product_unpublished] }

          include_examples "フィルタリングのテスト", "すべてのYahooFleamarketProductの値を返却すること"
        end

        context "yahoo_fleamarket.publishedの場合" do
          let(:platform_mask) { "yahoo_fleamarket.published" }
          let(:expected_products) { [yahoo_fleamarket_product_published] }

          include_examples "フィルタリングのテスト", "出品中のYahooFleamarketProductの値を返却すること"
        end

        context "yahoo_fleamarket.unpublishedの場合" do
          let(:platform_mask) { "yahoo_fleamarket.unpublished" }
          let(:expected_products) { [yahoo_fleamarket_product_unpublished] }

          include_examples "フィルタリングのテスト", "出品終了済みのYahooFleamarketProductの値を返却すること"
        end
      end

      context "mercariを指定した場合" do
        let!(:mercari_product_published) do
          create(:mercari_product, product:, name: "published", published: true)
        end
        let!(:mercari_product_unpublished) do
          create(:mercari_product, product:, name: "unpublished", published: false)
        end

        shared_examples "フィルタリングのテスト" do |description|
          it description do
            service = described_class.new(params: { product_id: product.id, platform_mask:,
                                                    sort: "created_at", order: "asc" })
            actual_array = service.call.products
            expected_array = expected_products.map do |product|
              product.attributes
                     .slice(*RelatedProduct.attribute_names)
                     .merge("platform" => "mercari")
            end

            expected_array.each_with_index do |expected, index|
              expect(actual_array[index]).to have_attributes(expected)
            end
          end
        end

        context "mercari.allの場合" do
          let(:platform_mask) { "mercari.all" }
          let(:expected_products) { [mercari_product_published, mercari_product_unpublished] }

          include_examples "フィルタリングのテスト", "すべてのMercariProductの値を返却すること"
        end

        context "mercari.publishedの場合" do
          let(:platform_mask) { "mercari.published" }
          let(:expected_products) { [mercari_product_published] }

          include_examples "フィルタリングのテスト", "出品中のMercariProductの値を返却すること"
        end

        context "mercari.unpublishedの場合" do
          let(:platform_mask) { "mercari.unpublished" }
          let(:expected_products) { [mercari_product_unpublished] }

          include_examples "フィルタリングのテスト", "出品終了済みのMercariProductの値を返却すること"
        end
      end

      context "janparaを指定した場合" do
        let!(:janpara_product_a) { create(:janpara_product, product:, name: "JanparaProduct A") }
        let!(:janpara_product_b) { create(:janpara_product, product:, name: "JanparaProduct B") }

        context "janpara.allの場合" do
          let!(:platform_mask) { "janpara.all" }
          let!(:expected_products) { [janpara_product_a, janpara_product_b] }

          it "すべてのJanparaProductの値を返却すること" do
            service = described_class.new(params: { product_id: product.id, platform_mask:,
                                                    sort: "created_at", order: "asc" })
            actual_array = service.call.products
            expected_array = expected_products.map do |product|
              product.attributes
                     .slice(*RelatedProduct.attribute_names)
                     .merge("platform" => "janpara")
            end

            expected_array.each_with_index do |expected, index|
              expect(actual_array[index]).to have_attributes(expected)
            end
          end
        end
      end
    end
  end
end
