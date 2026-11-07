module ProductMonitoring
  module Sites
    class YahooAuction
      HOST = "auctions.yahoo.co.jp".freeze
      PATH = %r{\A/(?:search/search|closedsearch/closedsearch)\z}
      PLATFORM = "yahoo_auction".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024
      LIST = Crawl::YahooAuction::SyncProducts::ListPage

      def self.validate_query(uri)
        raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
      end

      def self.fetch(uri)
        uri = search_uri(uri)
        Crawl::Client.execute(allow_images: true) do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          validate_page(page)
          LIST.wait_for_list(page)
          validate_page(page)
          page_results(uri, page)
        end
      end

      def self.page_results(uri, page)
        return [[], nil] if LIST.not_exist_results?(page)

        items = LIST.product_items(page)
        results = items.filter_map { |item| listing(item, closed: uri.path.start_with?("/closedsearch")) }
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
        return if LIST.not_crawlable?(item)

        price, buyout = closed ? [LIST.closed_price(item), nil] : LIST.published_prices(item)
        return if price.nil?

        id = LIST.external_id(item)
        return unless id.match?(/\A[a-zA-Z0-9_-]+\z/)

        end_date = LIST.auction_end_datetime(item, mode: closed ? :unpublished : :published)
        { external_id: id, name: LIST.name(item), price: price, buyout_price: buyout,
          product_url: "https://#{HOST}/jp/auction/#{id}", thumbnail_url: LIST.thumbnail_url(item),
          sold: closed, bought_date: closed ? end_date : nil, end_date: end_date }
      end

      def self.next_url(uri, page)
        return if LIST.not_exist_next_page?(page)

        Pagination.increment(uri, key: "b", default: "1", step: 100)
      end
    end
  end
end
