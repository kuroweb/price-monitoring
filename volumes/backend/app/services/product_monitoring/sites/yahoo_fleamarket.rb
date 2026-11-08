require "nokogiri"

module ProductMonitoring
  module Sites
    class YahooFleamarket
      HOST = "paypayfleamarket.yahoo.co.jp".freeze
      PATH = %r{\A/search/[^/]+\z}
      PLATFORM = "yahoo_fleamarket".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024
      DETAIL_DATE_UNITS = { "日" => :days, "週間" => :weeks, "ヶ月" => :months }.freeze

      def self.search_urls(keyword)
        ["https://#{HOST}/search/#{URI.encode_www_form_component(keyword).gsub("+", "%20")}"]
      end

      def self.validate_query(uri)
        keyword = URI::DEFAULT_PARSER.unescape(uri.path.delete_prefix("/search/"))
        raise ArgumentError, "Invalid search keyword" if keyword.blank? || keyword.match?(%r{[/\x00-\x1f\x7f]})
      end

      def self.fetch(uri)
        html = fetch_page(uri, allow_empty_search: true)
        return [[], nil] if html.nil?

        page = Nokogiri::HTML(html)
        results = page.css('a[href^="/item/"]').filter_map { |link| listing(link) }
        raise "Search page has no extractable listings" if results.empty?

        [results, next_url(uri, page)]
      end

      def self.listing(link)
        id = link["href"]&.match(%r{\A/item/([a-zA-Z0-9_-]+)\z})&.[](1)
        image = link.at_css('img:not([alt="sold"])')
        price = link.css("p").filter_map { |p| Crawler.parse_price(p.text) }.first
        return unless id && image && price

        { external_id: id, name: image["alt"].to_s.strip, price: price,
          product_url: "https://#{HOST}/item/#{id}", thumbnail_url: image["src"],
          sold: link.at_css('img[alt="sold"]').present? }
      end

      def self.next_url(uri, page)
        link = page.css("a[href]").find { |node| node.at_css('img[alt="次へボタンアイコン"]') }
        return unless link

        next_uri = URI.join(uri.to_s, link["href"])
        raise "Unexpected next page URL" unless valid_next_url?(next_uri, uri)

        next_uri
      end

      def self.valid_next_url?(next_uri, uri)
        next_uri.is_a?(URI::HTTPS) && next_uri.host == HOST && next_uri.port == 443 &&
          next_uri.path == uri.path && next_uri.userinfo.nil?
      end

      def self.fetch_detail(external_id)
        raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

        page = Nokogiri::HTML(fetch_page(URI("https://#{HOST}/item/#{external_id}")))
        sold = detail_sold(page)
        return {} if sold.nil?

        { sold: sold, bought_date: sold ? detail_bought_date(page) : nil }
      end

      def self.detail_sold(page)
        states = { "https://schema.org/OutOfStock" => true, "https://schema.org/InStock" => false }
        page.css('script[type="application/ld+json"]').each do |script|
          Mercari.json_ld_products(script).each do |product|
            next unless product.is_a?(Hash) && product["@type"] == "Product" && product["offers"].is_a?(Hash)

            result = states[product["offers"]["availability"]]
            return result unless result.nil?
          end
        end
        nil
      end

      def self.detail_bought_date(page)
        text = page.at_css('aside:has(> img[alt="時計アイコン"]) > span')&.text.to_s.strip
        parse_detail_date(text)
      end

      def self.parse_detail_date(text)
        case text
        when /\A\d+(?:分前|時間前)に更新\z/ then Time.current.beginning_of_day
        when /\A(\d+)(日|週間|ヶ月)前に更新\z/
          Regexp.last_match(1).to_i.public_send(DETAIL_DATE_UNITS[Regexp.last_match(2)]).ago.beginning_of_day
        when /\A半年前以上に更新\z/, /\A半年以上前に更新\z/ then Time.current.months_ago(6).beginning_of_day
        end
      end

      def self.fetch_page(uri, allow_empty_search: false)
        Crawl::Client.execute(allow_script_host: "paypayfleamarket.c.yimg.jp") do |page|
          response = page.goto(uri.to_s)
          status = response&.status
          validate_status(status, allow_empty_search)

          validate_page_url(page)
          sleep(2)
          validate_page_url(page)
          html = BrowserPage.content(page, max_bytes: MAX_RESPONSE_BYTES)

          search_response(html, uri, status)
        end
      end

      def self.validate_status(status, allow_empty_search)
        return if status&.between?(200, 299) || (allow_empty_search && status == 404)

        raise "Non-success HTTP response"
      end

      def self.search_response(html, uri, status)
        return html unless status == 404
        return nil if empty_search?(html, uri)

        raise "Non-success HTTP response"
      end

      def self.empty_search?(html, uri)
        data = JSON.parse(Nokogiri::HTML(html).at_css('script#__NEXT_DATA__[type="application/json"]')&.text.to_s)
        search = data.dig("props", "initialState", "searchState", "search")
        keyword = URI::DEFAULT_PARSER.unescape(uri.path.delete_prefix("/search/"))
        search.dig("searchParams", "query") == keyword &&
          search.dig("result", "metadata", "retriedWithVectorSearch") == true
      rescue JSON::ParserError, TypeError, NoMethodError
        false
      end

      def self.validate_page_url(page)
        BrowserPage.validate_url(page, host: HOST)
      end
    end
  end
end
