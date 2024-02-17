module Analysis
  module YahooAuction
    class EnqueueCalculatePriceJob
      include Sidekiq::Job

      def perform
        start_date = Time.current.ago(1.month).to_date.to_s
        end_date = Time.current.to_date.to_s
        job_params = Product.all.pluck(:id).map { |p| [p, start_date, end_date] }

        Analysis::YahooAuction::CalculatePriceJob.perform_bulk(job_params)
      end
    end
  end
end
