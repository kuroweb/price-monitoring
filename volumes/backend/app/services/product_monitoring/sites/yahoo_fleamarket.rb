require "nokogiri"

module ProductMonitoring
  module Sites
    class YahooFleamarket
      HOST = "paypayfleamarket.yahoo.co.jp".freeze
      PATH = %r{\A/search/[^/]+\z}
      PLATFORM = "yahoo_fleamarket".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024

      def self.validate_query(uri)
        keyword = URI::DEFAULT_PARSER.unescape(uri.path.delete_prefix("/search/"))
        raise ArgumentError, "Invalid search keyword" if keyword.blank? || keyword.match?(%r{[/\x00-\x1f\x7f]})
      end

      def self.fetch(uri) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        page = Nokogiri::HTML(fetch_page(uri))
        results = page.css('a[href^="/item/"]').filter_map do |link|
          id = link["href"]&.match(%r{\A/item/([a-zA-Z0-9_-]+)\z})&.[](1)
          image = link.at_css('img:not([alt="sold"])')
          price = link.css("p").filter_map { |p| Crawler.parse_price(p.text) }.first
          next unless id && image && price

          { external_id: id, name: image["alt"].to_s.strip, price: price,
            product_url: "https://#{HOST}/item/#{id}", thumbnail_url: image["src"],
            sold: link.at_css('img[alt="sold"]').present? }
        end
        raise "Search page has no extractable listings" if results.empty?

        [results, next_url(uri, page)]
      end

      def self.next_url(uri, page) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
        link = page.css("a[href]").find { |node| node.at_css('img[alt="次へボタンアイコン"]') }
        return unless link

        next_uri = URI.join(uri.to_s, link["href"])
        unless next_uri.is_a?(URI::HTTPS) && next_uri.host == HOST && next_uri.port == 443 &&
               next_uri.path == uri.path && next_uri.userinfo.nil?
          raise "Unexpected next page URL"
        end

        next_uri
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

      def self.detail_bought_date(page) # rubocop:disable Metrics/AbcSize
        text = page.at_css('aside:has(> img[alt="時計アイコン"]) > span')&.text.to_s.strip
        case text
        when /\A\d+(?:分前|時間前)に更新\z/ then Time.current.beginning_of_day
        when /\A(\d+)日前に更新\z/ then Time.current.days_ago(Regexp.last_match(1).to_i).beginning_of_day
        when /\A(\d+)ヶ月前に更新\z/ then Time.current.months_ago(Regexp.last_match(1).to_i).beginning_of_day
        when /\A半年前以上に更新\z/, /\A半年以上前に更新\z/ then Time.current.months_ago(6).beginning_of_day
        end
      end

      def self.fetch_page(uri)
        Crawl::Client.execute(allow_script_host: "paypayfleamarket.c.yimg.jp") do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          validate_page_url(page)
          sleep(2)
          validate_page_url(page)
          html = page.content
          raise "Response exceeds size limit" if html.bytesize > MAX_RESPONSE_BYTES

          html
        end
      end

      def self.validate_page_url(page)
        uri = URI.parse(page.url)
        return if uri.scheme == "https" && uri.host == HOST && uri.port == 443 && uri.userinfo.nil?

        raise "Unexpected page URL"
      end
    end
  end
end
