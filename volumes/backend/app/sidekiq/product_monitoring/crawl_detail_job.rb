module ProductMonitoring
  class CrawlDetailJob
    include Sidekiq::Job
    include Utils::TimeoutHandler

    sidekiq_options queue: :product_monitoring_crawl_detail_job,
                    retry: 2, lock: :until_executed

    sidekiq_retries_exhausted do |job, _exception|
      ProductCrawlResult.where(platform: job["args"][1] || "mercari", external_id: job["args"].first)
                        .update_all(updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
    end

    def perform(external_id, platform = "mercari")
      site = ProductMonitoring::UrlRouter.detail_site(platform)
      return unless site

      scope = ProductCrawlResult.where(platform: platform, external_id: external_id)
      return unless scope.exists?

      handle_timeout { update_results(scope, site.fetch_detail(external_id)) }
    end

    private

    def update_results(scope, detail)
      return scope.delete_all if detail[:deleted]
      return scope.update_all(updated_at: Time.current) unless detail.key?(:sold) # rubocop:disable Rails/SkipsModelValidations

      # 同一出品を一括更新し、並行処理で設定された売却日を上書きしない
      scope.update_all(sold: detail[:sold], updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
      return unless detail[:bought_date]

      scope.where(bought_date: nil).update_all(bought_date: detail[:bought_date]) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
