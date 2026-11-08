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
        BrowserPage.fetch(uri, host: HOST, max_bytes: MAX_RESPONSE_BYTES,
                               user_agent: Crawl::RequestBlocklist::JANPARA_USER_AGENT)
      end

      def self.next_url(uri, page)
        return unless page.at_css(".pageLink[title='次ページ']")

        Pagination.increment(uri, key: "PAGE", default: "1", step: 1, minimum: 2)
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
