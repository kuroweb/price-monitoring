module ProductMonitoring
  class EnqueueCrawlJobsJob
    include Sidekiq::Job

    sidekiq_options queue: :product_monitoring_enqueue_crawl_jobs_job, retry: 0

    def perform
      job_params = ProductCrawlSetting.where(enabled: true).pluck(:id).zip
      ProductMonitoring::CrawlJob.perform_bulk(job_params)
    end
  end
end
