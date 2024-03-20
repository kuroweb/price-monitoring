module Analysis
  module YahooAuction
    class CalculateDailyPurchaseSummaryJob
      include Sidekiq::Job

      BATCH_SIZE = 500

      sidekiq_options queue: :analysis_yahoo_auction, retry: 0

      def perform
        # TODO: 期間指定は後でいい感じに調整する
        start_date = "2024-01-01"
        end_date = Time.current.to_date.to_s

        Product.find_each(batch_size: BATCH_SIZE) do |product|
          Analysis::YahooAuction::CalculateDailyPurchaseSummary.call(product:, start_date:, end_date:)
        rescue StandardError
          Rails.logger.info("Skipping... id: #{product.id}")
        end
      end
    end
  end
end
