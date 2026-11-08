require "digest"
require "net/http"

module ProductMonitoring
  class LowestPriceNotifier
    def self.call(product_watch_setting:)
      new(product_watch_setting:).call
    end

    def self.webhook_uri
      uri = URI.parse(ENV.fetch("PRODUCT_MONITORING_DISCORD_WEBHOOK_URL", ""))
      return uri if uri.is_a?(URI::HTTPS) && uri.host == "discord.com" && uri.path.start_with?("/api/webhooks/")

      nil
    rescue URI::InvalidURIError
      nil
    end

    def self.configured?
      webhook_uri.present?
    end

    def initialize(product_watch_setting:)
      @product_watch_setting = product_watch_setting
    end

    def call
      product_watch_setting.with_lock do
        return unless product_watch_setting.enabled?

        evaluate
      end
    end

    private

    attr_reader :product_watch_setting

    def evaluate
      results = LowestListings.call(product_watch_setting: product_watch_setting)
      signature = lowest_signature(results)
      previous = product_watch_setting.last_lowest_signature
      return if previous == signature
      return if previous.present? && results.any? && self.class.configured? && !notify(results)

      product_watch_setting.update!(last_lowest_signature: signature)
    end

    def lowest_signature(results)
      Digest::SHA256.hexdigest(results.map { |r| [r.platform, r.external_id, r.price] }.sort.to_json)
    end

    def notify(results)
      uri = self.class.webhook_uri
      return false unless uri

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
        http.request(notification_request(uri, results))
      end
      return true if response.is_a?(Net::HTTPSuccess)

      Rails.logger.error("[ProductMonitoring::LowestPriceNotifier] Discord notification failed: HTTP #{response.code}")
      false
    rescue URI::InvalidURIError, IOError, SystemCallError, Timeout::Error, OpenSSL::SSL::SSLError => e
      Rails.logger.error("[ProductMonitoring::LowestPriceNotifier] Discord notification failed: #{e.class}")
      false
    end

    def notification_request(uri, results)
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      lines = results.first(5).map { |result| "#{result.name}: #{result.price}円\n#{result.product_url}" }
      request.body = { content: (["【商品モニタリング】#{product_watch_setting.name}"] + lines).join("\n").truncate(2000),
                       allowed_mentions: { parse: [] } }.to_json
      request
    end
  end
end
