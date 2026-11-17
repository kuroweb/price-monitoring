module ProductMonitoring
  module Crawling
    module Mercari
      module DetailPage
        class SyncJob
          include Sidekiq::Job

          sidekiq_options queue: :product_monitoring_mercari_detail_page_sync_job,
                          retry: 2, lock: :until_executed

          JOB_TIMEOUT = 30.minutes

          # 再試行を使い切った出品は、確認を後回しにするため更新日時だけ進める
          sidekiq_retries_exhausted do |job, _exception|
            ProductMonitoring::CrawlResult.where(platform: ListPage::SearchUrl::PLATFORM,
                                                 external_id: job["args"].first)
                                          .update_all(updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
          end

          def perform(external_id)
            Timeout.timeout(JOB_TIMEOUT) { Syncer.call(external_id:) }
          end
        end
      end
    end
  end
end
