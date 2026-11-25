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
        nil
      end

      private

      attr_reader :product
    end
  end
end
