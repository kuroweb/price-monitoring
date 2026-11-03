# 現在の計測設定とマッチしないレコードを削除する
module Products
  module Inspector
    class InspectAll
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        InspectYahooAuctionProducts.call(product:) if product.yahoo_auction_crawl_setting
        InspectYahooFleamarketProducts.call(product:) if product.yahoo_auction_crawl_setting
        InspectMercariProducts.call(product:) if product.mercari_crawl_setting
        InspectJanparaProducts.call(product:) if product.janpara_crawl_setting
        InspectIosysProducts.call(product:) if product.iosys_crawl_setting
        InspectPcKoubouProducts.call(product:) if product.pc_koubou_crawl_setting
        InspectUsedSofmapProducts.call(product:) if product.used_sofmap_crawl_setting
      end

      private

      attr_reader :product
    end
  end
end
