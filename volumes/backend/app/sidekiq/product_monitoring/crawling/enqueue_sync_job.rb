module ProductMonitoring
  module Crawling
    # 有効な計測設定ごとに、対象サイトの一覧ジョブを積む。失敗したサイトをジョブ名で見分けられるよう、取得はサイト単位で行う
    class EnqueueSyncJob
      include Sidekiq::Job

      sidekiq_options queue: :product_monitoring_enqueue_sync_job, retry: 0

      def perform
        ProductCrawlSetting.where(enabled: true).find_each do |product_crawl_setting|
          UrlRouter.call(product_crawl_setting:).each_key do |platform|
            platform::Listing::SyncJob.perform_async(product_crawl_setting.id)
          end
        rescue ArgumentError => e
          # 保存後に URL の条件を厳しくした設定があっても、ほかの設定の取得は止めない
          Rails.logger.error("Product crawl setting #{product_crawl_setting.id} has an invalid URL: #{e.message}")
        end
      end
    end
  end
end
