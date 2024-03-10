module Analysis
  module YahooAuction
    class EnqueueCalculatePriceJob
      include Sidekiq::Job

      sidekiq_options queue: :analysis_yahoo_auction

      def perform
        start_date = "2024-01-01"
        end_date = Time.current.to_date.to_s
        job_params = Product.all.pluck(:id).map { |p| [p, start_date, end_date] }

        Analysis::YahooAuction::CalculatePriceJob.perform_bulk(job_params)
      end
    end
  end
end
