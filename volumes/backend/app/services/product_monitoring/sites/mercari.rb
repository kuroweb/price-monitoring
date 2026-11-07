require "nokogiri"

module ProductMonitoring
  module Sites
    class Mercari
      extend MercariDetail

      HOST = "jp.mercari.com".freeze
      PATH = %r{\A/search\z}
      PLATFORM = "mercari".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024
      DELETED_TEXTS = ["ページが見つかりませんでした", "該当する商品は削除されています。"].freeze

      def self.validate_query(uri)
        raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
      end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_mercari_page(uri))
        results = mercari_results(page)
        if results.empty?
          empty = page.at_css(".merEmptyState")
          raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
        end
        [results, next_url(uri, page)]
      end

      def self.fetch_detail(external_id)
        raise ArgumentError, "Invalid external ID" unless external_id.match?(/\A[a-zA-Z0-9_-]+\z/)

        page = Nokogiri::HTML(fetch_mercari_page(URI("https://#{HOST}/item/#{external_id}")))
        sold = detail_sold(page)
        page.css("script, style").remove
        return { deleted: true } if deleted_detail?(page)
        return {} unless page.at_css("[data-testid='item-detail-container']") &&
                         page.at_css("[data-testid='price']") && !sold.nil?

        { sold: sold, bought_date: sold ? detail_bought_date(page) : nil }
      end

      def self.next_url(uri, page)
        return unless page.at_css("[data-testid='pagination-next-button']")

        query = URI.decode_www_form(uri.query)
        current = query.to_h.fetch("page_token", "v1:0").delete_prefix("v1:").to_i
        query.reject! { |key, _| key == "page_token" }
        query << ["page_token", "v1:#{current + 1}"]
        uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query) }
      end

      def self.fetch_mercari_page(uri)
        Crawl::Client.execute do |page|
          response = page.goto(uri.to_s)
          raise "Non-success HTTP response" unless response&.status&.between?(200, 299)

          validate_page_url(page)

          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
          checked_content(page)
        end
      end

      def self.checked_content(page)
        validate_page_url(page)
        BrowserPage.content(page, max_bytes: MAX_RESPONSE_BYTES)
      end

      def self.validate_page_url(page)
        BrowserPage.validate_url(page, host: HOST)
      end

      def self.mercari_results(page)
        Crawler.listing_nodes(page, "li[data-testid='item-cell']").filter_map do |dom|
          href = dom.at_css("a")&.[]("href")
          id = href&.match(%r{/item/([^/?]+)})&.[](1)
          next unless id

          mercari_listing(dom, id)
        end
      end

      def self.mercari_listing(dom, id)
        name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
        raise "Listing name is missing" if name.empty?

        price = Crawler.parse_price(dom.at_css("[data-testid='item-tile-price']")&.text)
        # 既存のメルカリクローラーと同じく、画像URLは external_id から組み立てる
        { external_id: id, name: name, price: price, product_url: "https://jp.mercari.com/item/#{id}",
          thumbnail_url: "https://static.mercdn.net/thumb/item/webp/#{id}_1.jpg",
          sold: dom.at_css("img[alt$='売り切れ']").present? }
      end
    end
  end
end
