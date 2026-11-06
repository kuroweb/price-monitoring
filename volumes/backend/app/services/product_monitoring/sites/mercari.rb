require "nokogiri"

module ProductMonitoring
  module Sites
    class Mercari
      HOST = "jp.mercari.com".freeze
      PATH = %r{\A/search\z}
      PLATFORM = "mercari".freeze

      def self.validate_query(_uri); end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_mercari_page(uri))
        results = mercari_results(page)
        if results.empty?
          empty = page.at_css(".merEmptyState")
          raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
        end
        [results, next_url(uri, page)]
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

          sleep(2)
          30.times do
            page.mouse.wheel(0, 200)
            sleep(0.005)
          end
          page.content
        end
      end

      def self.mercari_results(page)
        Crawler.listing_nodes(page, "li[data-testid='item-cell']").filter_map do |dom|
          href = dom.at_css("a")&.[]("href")
          id = href&.match(%r{/item/([^/?]+)})&.[](1)
          next unless id

          name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
          raise "Listing name is missing" if name.empty?

          price = Crawler.parse_price(dom.at_css("[data-testid='item-tile-price']")&.text)
          # 既存のメルカリクローラーと同じく、画像URLは external_id から組み立てる
          { external_id: id, name: name, price: price, product_url: "https://jp.mercari.com/item/#{id}",
            thumbnail_url: "https://static.mercdn.net/thumb/item/webp/#{id}_1.jpg" }
        end
      end
    end
  end
end
