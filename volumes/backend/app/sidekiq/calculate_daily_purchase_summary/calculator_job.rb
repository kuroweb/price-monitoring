module CalculateDailyPurchaseSummary
  class CalculatorJob
    include Sidekiq::Job

    BATCH_SIZE = 500

    sidekiq_options queue: :calculate_daily_purchase_summary, retry: 0

    def perform
      Product.find_each(batch_size: BATCH_SIZE) do |product|
        CalculateDailyPurchaseSummary::Calculator.call(product:)
      rescue StandardError
        Rails.logger.info("Skipping... id: #{product.id}")
      end
    end
  end
end
