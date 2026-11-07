module ProductMonitoring
  module Sites
    module BrowserPage
      def self.validate_url(page, host:, port: false, userinfo: false)
        uri = URI.parse(page.url)
        valid = uri.scheme == "https" && uri.host == host
        valid &&= uri.port == 443 if port
        valid &&= uri.userinfo.nil? if userinfo
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
