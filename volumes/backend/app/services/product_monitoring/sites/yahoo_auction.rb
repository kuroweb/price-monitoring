require "nokogiri"

module ProductMonitoring
  module Sites
    class YahooAuction
      HOST = "auctions.yahoo.co.jp".freeze
      PATH = %r{\A/(?:search/search|closedsearch/closedsearch)\z}
      PLATFORM = "yahoo_auction".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024
      PRODUCT_SELECTOR = 'li:has(> div a[href*="jp/auction/"])'.freeze
      TITLE_SELECTOR = 'a[href*="jp/auction/"].wb_break-all'.freeze
      PRICE_SELECTOR = '[class*="lg:grid-tc_1fr_160px"]'.freeze
      END_TIME_PATTERN = %r{(\d{1,2}/\d{1,2})\s+(\d{1,2}:\d{2})終了}
      REMAINING_TIME_PATTERN = /\A(?:(\d+)時間)?(?:(\d+)分)?(?:(\d+)秒)\z/
      LIST_READY = <<~JS.freeze
        () => document.querySelector('li:has(> div a[href*="jp/auction/"]), .Notice__wandQuery') ||
          document.body?.innerText.includes('条件に一致する商品は見つかりませんでした')
      JS

      def self.search_urls(keyword)
        query = URI.encode_www_form(p: keyword)
        ["https://#{HOST}/search/search?#{query}", "https://#{HOST}/closedsearch/closedsearch?#{query}"]
      end

      def self.validate_query(uri)
        raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
      end

      def self.fetch(uri)
        uri = search_uri(uri)
        Crawl::Client.execute(allow_images: true) do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          validate_page(page)
          page.wait_for_function(LIST_READY)
          html = validate_page(page)
          page_results(uri, Nokogiri::HTML(html))
        end
      end

      def self.page_results(uri, page)
        return [[], nil] if page.at_css(".Notice__wandQuery") ||
                            page.text.include?("条件に一致する商品は見つかりませんでした")

        closed = uri.path.start_with?("/closedsearch")
        results = page.css(PRODUCT_SELECTOR).filter_map { |item| listing(item, closed:) }
        raise "Search page has no extractable listings" if results.empty?

        [results, next_url(uri, page)]
      end

      def self.search_uri(uri)
        query = URI.decode_www_form(uri.query)
        query.reject! { |key, _| %w[mode n abatch].include?(key) }
        query.push(%w[mode 2], %w[n 100], ["abatch", "1,2"])
        uri.dup.tap { |result| result.query = URI.encode_www_form(query) }
      end

      def self.validate_page(page)
        BrowserPage.validate_url(page, host: HOST)
        BrowserPage.content(page, max_bytes: MAX_RESPONSE_BYTES)
      end

      def self.listing(item, closed:)
        title = item.at_css(TITLE_SELECTOR) || item.at_css('a[href*="jp/auction/"]')
        return unless title && item.at_css('a[href*="/seller/"]')

        price, buyout = prices(item, closed:)
        return if price.nil?

        id = title["href"].to_s.split("/").last.to_s
        return unless id.match?(/\A[a-zA-Z0-9_-]+\z/)

        end_date = end_datetime(item, closed:)
        { external_id: id, name: title.text.strip, price: price, buyout_price: buyout,
          product_url: "https://#{HOST}/jp/auction/#{id}", thumbnail_url: thumbnail_url(item),
          sold: closed, bought_date: closed ? end_date : nil, end_date: end_date }
      end

      def self.prices(item, closed:)
        text = (item.at_css(PRICE_SELECTOR) || item).text.gsub(/\s+/, "")
        current = text[closed ? /落札([\d,]+)円/ : /現在([\d,]+)円/, 1]
        buyout = closed ? nil : text[/即決([\d,]+)円/, 1]
        return [number(current), number(buyout)] if current
        return [number(buyout), nil] if buyout

        [nil, nil]
      end

      def self.number(value)
        value&.delete(",")&.to_i
      end

      def self.thumbnail_url(item)
        image = item.at_css("img")
        return if image.nil?

        return image["src"] if image["src"].present?
        return image["srcset"].split(",").first.strip.split.first if image["srcset"].present?

        image["data-src"].presence
      end

      def self.end_datetime(item, closed:)
        matched = item.text.match(END_TIME_PATTERN)
        datetime = parse_end_datetime(matched, closed:) if matched
        return datetime if datetime

        remaining_datetime(item)
      end

      def self.parse_end_datetime(matched, closed:)
        datetime = Time.zone.parse("#{Time.current.year}/#{matched[1]} #{matched[2]}")
        return if datetime.nil?

        Crawl::YahooAuction::SyncProducts::ListPage.adjust_year(datetime, mode: closed ? :unpublished : :published)
      end

      def self.remaining_datetime(item)
        item.css("span").each do |span|
          remaining = span.text.strip.match(REMAINING_TIME_PATTERN)
          next unless remaining

          hours, minutes, seconds = remaining.captures.map(&:to_i)
          total = (hours * 3600) + (minutes * 60) + seconds
          return Time.current + total.seconds if total.positive?
        end
        nil
      end

      def self.next_url(uri, page)
        return unless page.css("a").any? { |link| link.text.include?("次へ") }

        Pagination.increment(uri, key: "b", default: "1", step: 100)
      end
    end
  end
end
