require "net/http"
require "uri"

module Crawl
  class DynamicProxy
    CACHE_KEY = "crawl:dynamic_proxy:proxy_list".freeze
    CACHE_TTL = 1.day.to_i
    FETCH_TIMEOUT = 10

    class << self
      def get
        proxy = proxy_list.sample
        return if proxy.blank?

        proxy
      end

      def remove(proxy:)
        list = proxy_list
        return if list.blank?

        cache_list = list - [proxy]
        Rails.cache.write(CACHE_KEY, cache_list, expires_in: CACHE_TTL)
      end

      private

      def proxy_list
        cached_list = Rails.cache.read(CACHE_KEY)
        return cached_list if cached_list.present?

        refresh_cache!
      end

      def refresh_cache!
        source_list = fetch_proxy_list
        return source_list if source_list.blank?

        cache_list = source_list.map { |proxy_line| normalize(proxy_line) }
        Rails.cache.write(CACHE_KEY, cache_list, expires_in: CACHE_TTL)

        cache_list
      end

      def fetch_proxy_list
        uri = proxy_list_uri
        response = fetch_proxy_list_response(uri)
        return [] unless response.is_a?(Net::HTTPSuccess)

        response.body.split("\n").map(&:strip).compact_blank
      end

      def proxy_list_uri
        URI.parse(ENV.fetch("DYNAMIC_PROXY_LIST_URL"))
      end

      def fetch_proxy_list_response(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = FETCH_TIMEOUT
        http.read_timeout = FETCH_TIMEOUT
        http.request(Net::HTTP::Get.new(uri.request_uri))
      end

      def normalize(proxy_line)
        host, port, username, password = proxy_line.split(":")
        { server: "#{host}:#{port}", username:, password: }
      end
    end
  end
end
