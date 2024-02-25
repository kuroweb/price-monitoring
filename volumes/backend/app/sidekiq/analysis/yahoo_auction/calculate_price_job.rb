module Analysis
  module YahooAuction
    class CalculatePriceJob
      include Sidekiq::Job

      def perform(product_id, start_date, end_date)
        product = Product.find(product_id)
        start_date = start_date.to_date
        end_date = end_date.to_date

        Products::YahooAuctionProducts::DeleteByCrawlSetting.call(product:)
        Analysis::YahooAuction::CalculatePrice.call(product:, start_date:, end_date:)
      end
    end
  end
end
