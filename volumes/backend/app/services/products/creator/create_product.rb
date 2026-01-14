module Products
  module Creator
    class CreateProduct
      PRODUCT_ATTRIBUTES = %i[name].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(params: {})
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          product = create_product
          create_yahoo_auction_crawl_settings(product)
          create_mercari_crawl_settings(product)
          create_iosys_crawl_settings(product)
          create_janpara_crawl_settings(product)
          create_pc_koubou_crawl_settings(product)
          create_used_sofmap_crawl_settings(product)
          create_category_association(product)

          product
        end
      end

      private

      attr_reader :params

      def create_product
        attributes = params.slice(*PRODUCT_ATTRIBUTES) || {}
        Product.create!(attributes)
      end

      def create_yahoo_auction_crawl_settings(product)
        CreateYahooAuctionCrawlSettings.call(product:, params:)
      end

      def create_mercari_crawl_settings(product)
        CreateMercariCrawlSettings.call(product:, params:)
      end

      def create_iosys_crawl_settings(product)
        CreateIosysCrawlSettings.call(product:, params:)
      end

      def create_janpara_crawl_settings(product)
        CreateJanparaCrawlSettings.call(product:, params:)
      end

      def create_pc_koubou_crawl_settings(product)
        CreatePcKoubouCrawlSettings.call(product:, params:)
      end

      def create_used_sofmap_crawl_settings(product)
        CreateUsedSofmapCrawlSettings.call(product:, params:)
      end

      def create_category_association(product)
        return if params[:category_id].blank?

        category = Category.find(params[:category_id])
        product.category = category
      end
    end
  end
end
