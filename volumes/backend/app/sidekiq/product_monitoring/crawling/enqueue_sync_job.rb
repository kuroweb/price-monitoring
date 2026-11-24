module ProductMonitoring
  module Crawling
    # 指定したサイトについて、有効な収集設定ごとに一覧ジョブを積む。サイトごとに頻度を変えられるよう、スケジュールはサイト単位で登録する
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_enqueue_sync_job, retry: 0

      def perform(platform_name)
        platform = UrlRouter::PLATFORMS.find { |candidate| platform_name == candidate::ListPage::SearchUrl::PLATFORM }
        raise ArgumentError, "Platform #{platform_name} is unsupported" unless platform

        ProductMonitoring::CrawlSetting.where(enabled: true).find_each do |crawl_setting|
          next unless UrlRouter.call(crawl_setting:).key?(platform)

          platform::ListPage::SyncJob.perform_async(crawl_setting.id)
        rescue ArgumentError => e
          # 保存後に URL の条件を厳しくした設定があっても、ほかの設定の取得は止めない
          Rails.logger.error("Product crawl setting #{crawl_setting.id} has an invalid URL: #{e.message}")
        end
      end
    end
  end
end
