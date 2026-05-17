require "json"
require "net/http"
require "uri"

module Crawl
  module Backmarket
    class DiscordNotifier
      WEBHOOK_URL = ENV["BACKMARKET_DISCORD_WEBHOOK_URL"].to_s.freeze

      def self.call(...)
        new(...).call
      end

      def initialize(backmarket_watch_target:, backmarket_watch_result:, reasons:)
        @backmarket_watch_target = backmarket_watch_target
        @backmarket_watch_result = backmarket_watch_result
        @reasons = reasons
      end

      def call
        return if WEBHOOK_URL.blank?

        response = send_webhook
        return if response.is_a?(Net::HTTPSuccess)

        Rails.logger.error("[Backmarket::DiscordNotifier] Failed to notify: #{response.code} #{response.body}")
      rescue StandardError => e
        Rails.logger.error("[Backmarket::DiscordNotifier] Failed to notify: #{e.class} #{e.message}")
      end

      private

      attr_reader :backmarket_watch_target, :backmarket_watch_result, :reasons

      def send_webhook
        uri = URI.parse(WEBHOOK_URL)
        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"
        request.body = { content: message }.to_json

        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(request)
        end
      end

      def message
        [
          "【Backmarket差分通知】",
          "検知時刻: #{backmarket_watch_result.crawled_at.iso8601}",
          "件数: 1",
          "検知理由: #{reason_labels.join(" / ")}",
          "商品名: #{backmarket_watch_result.name}",
          "価格: #{price_text}",
          "在庫状態: #{backmarket_watch_result.stock_status}",
          "URL: #{backmarket_watch_target.url}"
        ].join("\n")
      end

      def price_text
        return "-" if backmarket_watch_result.price.blank?

        "¥#{backmarket_watch_result.price}"
      end

      def reason_labels
        reasons.map do |reason|
          case reason
          when :price_dropped
            "値下がり"
          when :restocked
            "在庫復活"
          else
            reason.to_s
          end
        end
      end
    end
  end
end
