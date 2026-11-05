require "uri"

module Crawl::Search
  class UrlRouter
    TARGETS = {
      "jp.mercari.com" => [%r{\A/search\z}, "mercari"],
      "iosys.co.jp" => [%r{\A/items/?\z}, "iosys"]
    }.freeze

    def self.call(url:)
      unless url.is_a?(String) && url.bytesize <= 2048 && !url.match?(/[\x00-\x20\x7f]/)
        raise ArgumentError,
              "URL must be an HTTPS search URL"
      end

      uri = URI.parse(url)
      unless uri.is_a?(URI::HTTPS) && uri.userinfo.nil? && (uri.port.nil? || uri.port == 443)
        raise ArgumentError,
              "URL must use HTTPS without credentials or a custom port"
      end

      target = TARGETS[uri.host&.downcase]
      raise ArgumentError, "URL host is unsupported" unless target
      raise ArgumentError, "URL path is unsupported" unless uri.path.match?(target[0])
      raise ArgumentError, "URL query is required" if uri.query.to_s.empty?

      { platform: target[1], canonical_url: uri.to_s }
    rescue URI::InvalidURIError
      raise ArgumentError, "URL is malformed"
    end
  end
end
