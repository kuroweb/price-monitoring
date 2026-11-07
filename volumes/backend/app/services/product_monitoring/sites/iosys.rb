require "net/http"
require "nokogiri"

module ProductMonitoring
  module Sites
    class Iosys
      HOST = "iosys.co.jp".freeze
      PATH = %r{\A/items/?\z}
      PLATFORM = "iosys".freeze
      MAX_RESPONSE_BYTES = 3 * 1024 * 1024

      def self.validate_query(uri)
        return unless URI.decode_www_form(uri.query).any? { |key, value| key == "t" && value == "g" }

        raise ArgumentError, "イオシスは個別出品の検索URL（t=gなし）を指定してください"
      end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_page(uri).body)
        results = iosys_results(page)
        if results.empty?
          empty = page.at_css("#empty")
          raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
        end
        [results, next_url(uri, page)]
      end

      def self.next_url(uri, page)
        return unless page.at_css(".page-link[rel='next']")

        query = URI.decode_www_form(uri.query)
        current = query.to_h.fetch("page", "1").to_i
        query.reject! { |key, _| key == "page" }
        query << ["page", [(current + 1), 2].max.to_s]
        uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
      end

      # 取得先は UrlRouter で許可したホストの検索ページに限る。リダイレクトは追わず、応答は読み取り中に打ち切る
      def self.fetch_page(uri)
        http = build_http(uri)
        request = Net::HTTP::Get.new(uri.request_uri, { "User-Agent" => Crawl::RequestBlocklist::USER_AGENT })
        body = +""
        response = http.start do |connection|
          connection.request(request) { |incoming| read_response(incoming, body) }
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

      def self.read_response(incoming, body)
        raise "Redirects and non-success HTTP responses are rejected" unless incoming.is_a?(Net::HTTPSuccess)

        incoming.read_body do |chunk|
          raise "Response exceeds size limit" if body.bytesize + chunk.bytesize > MAX_RESPONSE_BYTES

          body << chunk
        end
      end

      def self.iosys_results(page)
        Crawler.listing_nodes(page, "li.item").filter_map do |dom|
          href = dom.at_css("a")&.[]("href")
          id = href&.match(%r{/items/([^?#]+)})&.[](1)
          next unless id

          iosys_listing(dom, id)
        end
      end

      def self.iosys_listing(dom, id)
        name = dom.at_css(".name")&.text.to_s.strip
        raise "Listing name is missing" if name.empty?

        image_url = thumbnail_url(dom)
        { external_id: id, name: name, price: Crawler.parse_price(dom.at_css(".price")&.text), product_url: "https://iosys.co.jp/items/#{id}",
          thumbnail_url: image_url, sold: false }
      end

      def self.thumbnail_url(dom)
        image = dom.at_css("img")
        image_url = image&.[]("data-src").presence || image&.[]("src")
        image_url.present? ? URI.join("https://iosys.co.jp", image_url).to_s : nil
      end
    end
  end
end
