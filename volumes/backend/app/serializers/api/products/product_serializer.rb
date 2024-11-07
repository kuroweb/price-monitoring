module Api
  module Products
    class ProductSerializer < BaseSerializer
      def initialize(product)
        @product = product
      end

      private

      def json
        product_json.merge(
          {
            yahoo_auction_crawl_setting: yahoo_auction_crawl_setting_json,
            mercari_crawl_setting: mercari_crawl_setting_json,
            janpara_crawl_setting: janpara_crawl_setting_json,
            iosys_crawl_setting: iosys_crawl_setting_json,
            pc_koubou_crawl_setting: pc_koubou_crawl_setting_json,
            used_sofmap_crawl_setting: used_sofmap_crawl_setting_json,
            category: category_json
          }
        )
      end

      def product_json
        @product.as_json
      end

      def yahoo_auction_crawl_setting_json
        YahooAuctionCrawlSettingSerializer.new(@product.yahoo_auction_crawl_setting).render_json
      end

      def mercari_crawl_setting_json
        MercariCrawlSettingSerializer.new(@product.mercari_crawl_setting).render_json
      end

      def janpara_crawl_setting_json
        JanparaCrawlSettingSerializer.new(@product.janpara_crawl_setting).render_json
      end

      def iosys_crawl_setting_json
        IosysCrawlSettingSerializer.new(@product.iosys_crawl_setting).render_json
      end

      def pc_koubou_crawl_setting_json
        PcKoubouCrawlSettingSerializer.new(@product.pc_koubou_crawl_setting).render_json
      end

      def used_sofmap_crawl_setting_json
        UsedSofmapCrawlSettingSerializer.new(@product.used_sofmap_crawl_setting).render_json
      end

      def category_json
        CategorySerializer.new(@product.category).render_json
      end
    end
  end
end
