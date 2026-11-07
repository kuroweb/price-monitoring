module ProductMonitoring
  module Sites
    module BrowserPage
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
