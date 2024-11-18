module Api
  module Products
    class ProductListSerializer
      JSON_OPTIONS = {
        include: %i[
          yahoo_auction_crawl_setting
          mercari_crawl_setting
          janpara_crawl_setting
          iosys_crawl_setting
          pc_koubou_crawl_setting
          used_sofmap_crawl_setting
        ]
      }.freeze

      def initialize(products)
        @products = products
      end

      def as_json(_opts = {})
        {
          products: @products.as_json(JSON_OPTIONS)
        }
      end
    end
  end
end
