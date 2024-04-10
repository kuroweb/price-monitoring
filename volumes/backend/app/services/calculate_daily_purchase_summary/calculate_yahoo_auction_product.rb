# ヤフオク落札価格集計クラス
module CalculateDailyPurchaseSummary
  class CalculateYahooAuctionProduct
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
          date:,
          average_purchase_price: calculate_result_map[date.to_s]&.average_purchase_price,
          purchase_count: calculate_result_map[date.to_s]&.purchase_count || 0
        }
      end
    end

    def calculate_result_map
      @calculate_result_map ||=
        product
        .yahoo_auction_products
        .where(bought_date: start_date.to_datetime.beginning_of_day..end_date.to_datetime.end_of_day)
        .group("date")
        .select(
          <<~SQL
            DATE(yahoo_auction_products.bought_date) AS date,
            AVG(yahoo_auction_products.price) AS average_purchase_price,
            COUNT(yahoo_auction_products.id) AS purchase_count
          SQL
        )
        .index_by { |result| result.date.to_s }
    end

    def save(calculate_results)
      YahooAuctionDailyPurchaseSummary.transaction do
        YahooAuctionDailyPurchaseSummary.upsert_all(calculate_results)
      end
    end
  end
end
