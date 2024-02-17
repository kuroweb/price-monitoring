module Analysis
  module YahooAuction
    class CalculatePrice
      def self.call(...)
        new(...).call
      end

      def initialize(product:, start_date:, end_date:)
        @product = product
        @start_date = start_date
        @end_date = end_date
      end

      def call
        calculate_results = fetch_calculate_results
        save(calculate_results)
      end

      private

      attr_reader :product, :start_date, :end_date

      def fetch_calculate_results
        (start_date.to_date..end_date.to_date).to_a.map do |date|
          {
            product_id: product.id,
            target_date: date,
            price: calculate_result_map[date.to_s]&.price
          }
        end
      end

      def calculate_result_map
        @calculate_result_map ||=
          product
          .yahoo_auction_products.bought
          .where(bought_date: start_date.to_datetime.beginning_of_day..end_date.to_datetime.end_of_day)
          .group("target_date")
          .select("DATE(yahoo_auction_products.bought_date) AS target_date, " \
                         "AVG(yahoo_auction_products.price) AS price")
          .index_by { |result| result.target_date.to_s }
      end

      def save(calculate_results)
        ApplicationRecord.transaction do
          CalculateDailyYahooAuctionProduct.upsert_all(calculate_results)
        end
      end
    end
  end
end
