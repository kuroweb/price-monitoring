module Crawl
  module Backmarket
    class SyncJob
      include Sidekiq::Job
      include Utils::TimeoutHandler

      sidekiq_options queue: :crawl_backmarket_sync_job,
                      retry: 0, lock: :until_executed

      def perform(backmarket_watch_target_id)
        backmarket_watch_target = BackmarketWatchTarget.find(backmarket_watch_target_id)
        handle_timeout { Crawl::Backmarket::Syncer.call(backmarket_watch_target:) }
      end
    end
  end
end
