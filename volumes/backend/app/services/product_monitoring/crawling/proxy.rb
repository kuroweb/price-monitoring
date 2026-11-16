module ProductMonitoring
  module Crawling
    # サイトへはサーバーの IP から直接つながず、プロキシ一覧から選んだプロキシを経由する
    class Proxy
      class Unavailable < StandardError; end

      CACHE_KEY = "product_monitoring:crawling:proxy_list".freeze
      CACHE_TTL = 1.day
      FETCH_TIMEOUT = 10

      def self.call
        new.call
      end

      # プロキシが無ければ取得を止める
      def call
        proxies.sample || raise(Unavailable, "Proxy is unavailable")
      end

      private

      def proxies
        cached = Rails.cache.read(CACHE_KEY)
        return cached if cached.present?

        fetched = fetch_list.map { |line| parse(line) }
        Rails.cache.write(CACHE_KEY, fetched, expires_in: CACHE_TTL) if fetched.any?
        fetched
      end

      def fetch_list
        uri = URI.parse(ENV.fetch("DYNAMIC_PROXY_LIST_URL"))
        options = { use_ssl: uri.scheme == "https", open_timeout: FETCH_TIMEOUT, read_timeout: FETCH_TIMEOUT }
        response = Net::HTTP.start(uri.host, uri.port, **options) { |http| http.request(Net::HTTP::Get.new(uri.request_uri)) }
        return [] unless response.is_a?(Net::HTTPSuccess)

        response.body.split("\n").map(&:strip).compact_blank
      end

      def parse(line)
        host, port, username, password = line.split(":")
        { server: "#{host}:#{port}", username:, password: }
      end
    end
  end
end
