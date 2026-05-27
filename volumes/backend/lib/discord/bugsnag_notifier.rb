module Discord
  class BugsnagNotifier
    def self.call(...)
      new(...).call
    end

    def initialize(report:)
      @report = report
    end

    def call
      return unless configured?

      deliver
    end

    private

    def deliver
      uri = URI.parse(webhook_url)
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = { embeds: [embed] }.to_json

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(request) }
      return if response.is_a?(Net::HTTPSuccess)

      Rails.logger.error("[Discord::BugsnagNotifier] Failed: #{response.code} #{response.body}")
    rescue StandardError => e
      Rails.logger.error("[Discord::BugsnagNotifier] Failed: #{e.class} #{e.message}")
    end

    def embed
      BugsnagEmbed.call(report: @report)
    end

    def configured?
      webhook_url.present?
    end

    def webhook_url
      ENV.fetch("BUGSNAG_DISCORD_WEBHOOK_URL", nil)
    end
  end
end
