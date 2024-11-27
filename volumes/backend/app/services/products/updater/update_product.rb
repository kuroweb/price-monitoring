module Products
  module Updater
    class UpdateProduct
      PRODUCT_ATTRIBUTES = %i[name].freeze
      YAHOO_AUCTION_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
      MERCARI_CRAWL_SETTING_ATTRIBUTES = %i[keyword category_id min_price max_price enabled].freeze
      JANPARA_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
      IOSYS_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
      PC_KOUBOU_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze
      USED_SOFMAP_CRAWL_SETTING_ATTRIBUTES = %i[keyword min_price max_price enabled].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(product:, params: {})
        @product = product
        @params = params
      end

      def call
        ApplicationRecord.transaction do
          update_product
          update_yahoo_auction_crawl_settings
          update_mercari_crawl_settings
          update_iosys_crawl_settings
          update_janpara_crawl_settings
          update_pc_koubou_crawl_settings
          update_used_sofmap_crawl_settings
          update_category_association

          product
        end
      end

      private

      attr_reader :product, :params

      def update_product
        attributes = params.slice(*PRODUCT_ATTRIBUTES) || {}
        product.update!(attributes)
      end

      def update_yahoo_auction_crawl_settings
        UpdateYahooAuctionCrawlSettings.call(product:, params:)
      end

      def update_mercari_crawl_settings
        UpdateMercariCrawlSettings.call(product:, params:)
      end

      def update_iosys_crawl_settings
        UpdateIosysCrawlSettings.call(product:, params:)
      end

      def update_janpara_crawl_settings
        UpdateJanparaCrawlSettings.call(product:, params:)
      end

      def update_pc_koubou_crawl_settings
        UpdatePcKoubouCrawlSettings.call(product:, params:)
      end

      def update_used_sofmap_crawl_settings
        UpdateUsedSofmapCrawlSettings.call(product:, params:)
      end

      def update_category_association
        category = Category.find(params[:category_id])
        product.category = category
      end
    end
  end
end
