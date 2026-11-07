module ProductCrawlSettings
  class SyncDetailJob
    include Sidekiq::Job
    include Utils::TimeoutHandler

    sidekiq_options queue: :product_crawl_settings_sync_detail_job,
                    retry: 2, lock: :until_executed

    def perform(external_id)
      scope = ProductCrawlResult.where(platform: "mercari", external_id: external_id)
      return unless scope.exists?

      handle_timeout do
        detail = ProductMonitoring::Sites::Mercari.fetch_detail(external_id)
        if detail[:deleted]
          scope.delete_all
        elsif detail.key?(:sold)
          # 同一出品を一括更新し、並行処理で設定された売却日を上書きしない
          scope.update_all(sold: detail[:sold]) # rubocop:disable Rails/SkipsModelValidations
          if detail[:bought_date]
            scope.where(bought_date: nil).update_all(bought_date: detail[:bought_date]) # rubocop:disable Rails/SkipsModelValidations
          end
        end
      end
    end
  end
end
