# 現在の計測設定とマッチしないレコードを削除する
module Products
  module RefreshRelatedProduct
    class Refresh
      def self.call(...)
        new(...).call
      end

      def initialize(product:)
        @product = product
      end

      def call
        RefreshMercariProduct.call(product:)
        RefreshYahooAuctionProduct.call(product:)
        RefreshYahooFleamarketProduct.call(product:)
      end

      private

      attr_reader :product
    end
  end
end
