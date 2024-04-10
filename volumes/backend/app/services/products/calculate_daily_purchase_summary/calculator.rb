# 購入相場を集計するクラス
module Products
  module CalculateDailyPurchaseSummary
    class Calculator
      def self.call(...)
        new(...).call
      end

      def initialize(product:, start_date: nil, end_date: nil)
        @product = product
        @start_date = start_date || Time.current.ago(1.month).to_s
        @end_date = end_date || Time.current.to_date.to_s
      end

      def call
        CalculateMercariProduct.call(product:, start_date:, end_date:)
        CalculateYahooAuctionProduct.call(product:, start_date:, end_date:)
      end

      private

      attr_reader :product, :start_date, :end_date
    end
  end
end
