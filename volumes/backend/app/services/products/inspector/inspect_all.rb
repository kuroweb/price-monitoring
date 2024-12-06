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
        ::InspectYahooAuctionProducts.call(product:)
        ::InspectYahooFleamarketProducts.call(product:)
        ::InspectMercariProducts.call(product:)
        ::InspectJanparaProducts.call(product:)
        ::InspectIosysProducts.call(product:)
        ::InspectPcKoubouProducts.call(product:)
        ::InspectUsedSofmapProducts.call(product:)
      end

      private

      attr_reader :product
    end
  end
end
