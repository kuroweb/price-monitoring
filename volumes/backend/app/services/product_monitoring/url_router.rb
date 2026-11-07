require "uri"

module ProductMonitoring
  class UrlRouter
    SITES = [Sites::Mercari, Sites::Iosys, Sites::YahooFleamarket].freeze

    def self.call(...)
      new(...).call
    end

    def initialize(url:)
      @url = url
    end

    def call
      validate_url
      uri = URI.parse(url)
      validate_uri(uri)
      target = SITES.find { |site| uri.host&.downcase == site::HOST }
      raise ArgumentError, "URL host is unsupported" unless target

      validate_target(uri, target)

      { platform: target::PLATFORM, canonical_url: uri.to_s, site: target }
    rescue URI::InvalidURIError
      raise ArgumentError, "URL is malformed"
    end

    private

    attr_reader :url

    def validate_target(uri, target)
      raise ArgumentError, "URL path is unsupported" unless uri.path.match?(target::PATH)

      target.validate_query(uri)
    end

    def validate_url
      return if url.is_a?(String) && url.bytesize <= 2048 && !url.match?(/[\x00-\x20\x7f]/)

      raise ArgumentError, "URL must be an HTTPS search URL"
    end

    def validate_uri(uri)
      return if uri.is_a?(URI::HTTPS) && uri.userinfo.nil? && (uri.port.nil? || uri.port == 443)

      raise ArgumentError, "URL must use HTTPS without credentials or a custom port"
    end
  end
end
