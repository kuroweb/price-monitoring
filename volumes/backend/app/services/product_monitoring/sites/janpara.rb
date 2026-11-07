require "nokogiri"

module ProductMonitoring
  module Sites
    class Janpara
      HOST = "www.janpara.co.jp".freeze
      PATH = %r{\A/sale/search/result/\z}
      PLATFORM = "janpara".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024

      def self.validate_query(uri)
        return if URI.decode_www_form(uri.query.to_s).any? { |key, value| key == "KEYWORDS" && value.strip.present? }

        raise ArgumentError, "KEYWORDS is required"
      end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_page(uri))
        results = listings(page)
        raise "Search page has no extractable listings" if results.empty? && !page.at_css(".sorry")

        [results, next_url(uri, page)]
      end

      def self.fetch_page(uri)
        Crawl::Client.execute(block_scripts: true, user_agent: Crawl::RequestBlocklist::JANPARA_USER_AGENT) do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          checked_content(page)
        end
      end

      def self.checked_content(page)
        final_uri = URI.parse(page.url)
        unless final_uri.scheme == "https" && final_uri.host == HOST && final_uri.port == 443
          raise "Unexpected page URL"
        end

        html = page.content
        raise "Response exceeds size limit" if html.bytesize > MAX_RESPONSE_BYTES

        html
      end

      def self.next_url(uri, page)
        return unless page.at_css(".pageLink[title='次ページ']")

        query = URI.decode_www_form(uri.query)
        current = query.to_h.fetch("PAGE", "1").to_i
        query.reject! { |key, _| key == "PAGE" }
        query << ["PAGE", [current + 1, 2].max.to_s]
        uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
      end

      def self.listings(page)
        Crawler.listing_nodes(page, ".search_item_s").filter_map do |dom|
          id = listing_id(dom)
          next unless id

          listing(dom, id)
        end
      end

      def self.listing_id(dom)
        href = dom.at_css(".search_itemlink")&.[]("href")
        return unless href

        link = URI.join("https://#{HOST}", href)
        return unless link.host == HOST && link.path == "/sale/search/detail/"

        URI.decode_www_form(link.query.to_s).find do |key, value|
          %w[SRCODE ITMCODE].include?(key) && value.match?(/\A\d+\z/)
        end
      end

      def self.listing(dom, id)
        name = dom.at_css(".search_itemname")&.text.to_s.strip.gsub(/\R/, "")
        raise "Listing name is missing" if name.empty?

        image = dom.at_css("img")&.[]("src")
        external_id = id.join("=")
        { external_id: external_id, name: name, price: listing_price(dom),
          product_url: "https://#{HOST}/sale/search/detail/?#{external_id}",
          thumbnail_url: image.present? ? URI.join("https://#{HOST}", image).to_s : nil, sold: false }
      end

      def self.listing_price(dom)
        amounts = dom.css(".item_amount")
        return if amounts.size > 2

        amount = amounts.size == 2 ? amounts[1] : amounts[0]
        Crawler.parse_price(amount&.text.to_s.strip.sub(/～\z/, ""))
      end
    end
  end
end
