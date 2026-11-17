module ProductMonitoring
  module Notification
    class LowestPriceNotifier
      def self.call(monitor:)
        new(monitor:).call
      end

      def initialize(monitor:)
        @monitor = monitor
      end

      def call
        # 比較から送信・基準更新まで直列化し、同じ変化の重複通知や条件変更との競合を防ぐ
        monitor.with_lock do
          return unless monitor.enabled?

          evaluate
        end
      end

      private

      attr_reader :monitor

      def evaluate
        results = Search::LowestCrawlResults.call(monitor: monitor)
        signature = lowest_signature(results)
        previous = monitor.last_lowest_signature
        return if previous == signature
        return if previous.present? && results.any? && DiscordWebhook.configured? &&
                  !DiscordWebhook.post(content(results))

        monitor.update!(last_lowest_signature: signature)
      end

      def lowest_signature(results)
        Digest::SHA256.hexdigest(results.map { |r| [r.platform, r.external_id, r.price] }.sort.to_json)
      end

      def content(results)
        lines = results.first(5).map { |result| "#{result.name}: #{result.price}円\n#{result.product_url}" }
        (["【商品モニタリング】#{monitor.name}"] + lines).join("\n")
      end
    end
  end
end
