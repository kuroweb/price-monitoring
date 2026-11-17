module ProductMonitoring
  module Notification
    # 通知先の Discord Webhook。最安値通知と新着通知が使う
    class DiscordWebhook
      def self.uri
        uri = URI.parse(ENV.fetch("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL", ""))
        return uri if uri.is_a?(URI::HTTPS) && uri.host == "discord.com" && uri.path.start_with?("/api/webhooks/")

        nil
      rescue URI::InvalidURIError
        nil
      end

      def self.configured?
        uri.present?
      end

      # 送信できたら true を返す
      def self.post(content)
        uri = self.uri
        return false unless uri

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
          http.request(request(uri, content))
        end
        return true if response.is_a?(Net::HTTPSuccess)

        Rails.logger.error("[ProductMonitoring::Notification::DiscordWebhook] Discord notification failed: " \
                           "HTTP #{response.code}")
        false
      rescue URI::InvalidURIError, IOError, SystemCallError, Timeout::Error, OpenSSL::SSL::SSLError => e
        Rails.logger.error("[ProductMonitoring::Notification::DiscordWebhook] Discord notification failed: " \
                           "#{e.class}")
        false
      end

      def self.request(uri, content)
        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"
        request.body = { content: content.truncate(2000), allowed_mentions: { parse: [] } }.to_json
        request
      end
      private_class_method :request
    end
  end
end
