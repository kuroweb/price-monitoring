module Discord
  class UrlResolver
    API_BASE = "https://api.bugsnag.com"

    def self.call(...)
      new(...).call
    end

    def initialize(event_id:)
      @event_id = event_id
    end

    def call
      return unless configured?
      return if @event_id.blank?

      error_id = fetch_error_id
      dashboard_url(error_id) if error_id.present?
    rescue JSON::ParserError, StandardError => e
      Rails.logger.warn("[Discord::UrlResolver] failed: #{e.class} #{e.message}")
      nil
    end

    private

    def configured?
      auth_token.present? && project_id.present? && project_url.present?
    end

    def dashboard_url(error_id)
      query = []
      query << "event_id=#{@event_id}" if @event_id.present?
      query << "filters[app.release_stage]=#{Rails.env}"
      "#{project_url}/errors/#{error_id}?#{query.join('&')}"
    end

    def fetch_error_id
      uri = URI("#{API_BASE}/projects/#{project_id}/events/#{@event_id}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "token #{auth_token}"
      request["X-Version"] = "2"

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(request) }
      return unless response.is_a?(Net::HTTPSuccess)

      body = JSON.parse(response.body)
      body["error_id"].presence ||
        body.dig("relationships", "error", "data", "id").presence ||
        body["url"].to_s[%r{/errors/([a-f0-9]+)}i, 1]
    end

    def auth_token
      ENV.fetch("BUGSNAG_AUTH_TOKEN", nil)
    end

    def project_id
      ENV.fetch("BUGSNAG_PROJECT_ID", nil)
    end

    def project_url
      ENV.fetch("BUGSNAG_PROJECT_URL", nil)
    end
  end
end
