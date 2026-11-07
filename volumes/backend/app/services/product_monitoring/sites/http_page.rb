require "net/http"

module ProductMonitoring
  module Sites
    # 取得先は UrlRouter で許可したホストの検索ページに限る。リダイレクトは追わず、応答は読み取り中に打ち切る
    module HttpPage
      def self.fetch(uri, max_bytes:)
        http = build_http(uri)
        request = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => Crawl::RequestBlocklist::USER_AGENT })
        body = +""
        response = http.start do |connection|
          connection.request(request) { |incoming| read_response(incoming, body, max_bytes) }
        end
        raise "Redirects and non-success HTTP responses are rejected" unless response.is_a?(Net::HTTPSuccess)

        response.body = body
        response
      end

      def self.build_http(uri)
        http = Net::HTTP.new(uri.host, 443, nil)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.open_timeout = 5
        http.read_timeout = 15
        http.write_timeout = 5 if http.respond_to?(:write_timeout=)
        http
      end

      def self.read_response(incoming, body, max_bytes)
        raise "Redirects and non-success HTTP responses are rejected" unless incoming.is_a?(Net::HTTPSuccess)

        incoming.read_body do |chunk|
          raise "Response exceeds size limit" if body.bytesize + chunk.bytesize > max_bytes

          body << chunk
        end
      end
    end
  end
end
