module ProductMonitoring
  module Sites
    module BrowserPage
      class NonSuccessResponse < StandardError; end

      # 旧クローラと同じ回数。イオシスではプロキシの約3割が 403 を返す
      FETCH_TRIES = 5

      # JavaScript なしで描画される一覧を、プロキシ経由のブラウザでスクリプトを止めて取得する。
      # サイトに拒否されるプロキシがあるので、非 2xx なら接続し直して別のプロキシで試す
      def self.fetch(uri, host:, max_bytes:, **client_options)
        Retryable.retryable(tries: FETCH_TRIES, on: NonSuccessResponse) do
          Crawl::Client.execute(block_scripts: true, **client_options) do |page|
            response = page.goto(uri.to_s)
            raise NonSuccessResponse, "Non-success HTTP response" unless response&.status&.between?(200, 299)

            validate_url(page, host:)
            content(page, max_bytes:)
          end
        end
      end

      def self.validate_url(page, host:)
        uri = URI.parse(page.url)
        valid = uri.scheme == "https" && uri.host == host && uri.port == 443 && uri.userinfo.nil?
        raise "Unexpected page URL" unless valid
      end

      def self.content(page, max_bytes:)
        html = page.content
        raise "Response exceeds size limit" if html.bytesize > max_bytes

        html
      end
    end
  end
end
