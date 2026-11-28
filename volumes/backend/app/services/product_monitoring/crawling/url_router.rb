module ProductMonitoring
  module Crawling
    class UrlRouter
      PLATFORMS = [Mercari, Iosys, Janpara, YahooFleamarket, YahooAuction, TreasureFactory].freeze

      def self.call(...)
        new(...).call
      end

      def initialize(crawl_setting:)
        @crawl_setting = crawl_setting
      end

      def call
        (generated_urls + crawl_setting.search_urls).each_with_object({}) do |url, urls_by_platform|
          (urls_by_platform[route(url)] ||= []) << url
        end
      end

      private

      attr_reader :crawl_setting

      def generated_urls
        crawl_setting.platforms.flat_map do |name|
          search_url = PLATFORMS.find { |platform| name == platform::ListPage::SearchUrl::PLATFORM }::ListPage::SearchUrl
          search_url.build(crawl_setting.search_keyword)
        end
      end

      def route(url)
        validate_url(url)
        uri = URI.parse(url)
        validate_uri(uri)
        platform = PLATFORMS.find { |candidate| uri.host&.downcase == candidate::ListPage::SearchUrl::HOST }
        raise ArgumentError, "URL host is unsupported" unless platform

        search_url = platform::ListPage::SearchUrl
        raise ArgumentError, "URL path is unsupported" unless uri.path.match?(search_url::PATH)

        search_url.validate(uri)
        platform
      rescue URI::InvalidURIError
        raise ArgumentError, "URL is malformed"
      end

      def validate_url(url)
        return if url.is_a?(String) && url.bytesize <= 2048 && !url.match?(/[\x00-\x20\x7f]/)

        raise ArgumentError, "URL must be an HTTPS search URL"
      end

      def validate_uri(uri)
        return if uri.is_a?(URI::HTTPS) && uri.userinfo.nil? && (uri.port.nil? || uri.port == 443)

        raise ArgumentError, "URL must use HTTPS without credentials or a custom port"
      end
    end
  end
end
