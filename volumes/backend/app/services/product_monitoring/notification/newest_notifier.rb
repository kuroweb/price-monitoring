module ProductMonitoring
  module Notification
    class NewestNotifier
      # 保存のトランザクションが確定するまでの余裕。これより新しい行は次の評価に回す
      SETTLE_DELAY = 5.minutes

      def self.call(monitor:)
        new(monitor:).call
      end

      def initialize(monitor:)
        @monitor = monitor
      end

      def call
        # 比較から送信・基準更新まで直列化し、同じ新着の重複通知や条件変更との競合を防ぐ
        monitor.with_lock do
          return unless monitor.newest_notification_enabled?

          evaluate
        end
      end

      private

      attr_reader :monitor

      # 初回は基準だけ保存する。範囲は前回の終わりより後から、今から SETTLE_DELAY 前までで、重ならない
      def evaluate
        up_to = Time.current - SETTLE_DELAY
        after = monitor.newest_notified_until
        if after
          results = Search::NewlySavedCrawlResults.call(monitor:, after:, up_to:)
          return if results.any? && DiscordWebhook.configured? && !DiscordWebhook.post(content(results))
        end

        monitor.update!(newest_notified_until: up_to)
      end

      def content(results)
        lines = results.first(5).map { |result| "#{result.name}: #{result.price}円\n#{result.product_url}" }
        (["【商品モニタリング】#{monitor.name} 新着#{results.size}件"] + lines).join("\n")
      end
    end
  end
end
