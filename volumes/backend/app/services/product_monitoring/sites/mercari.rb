require "nokogiri"

module ProductMonitoring
  module Sites
    class Mercari
      HOST = "jp.mercari.com"
      PATH = %r{\A/search\z}
      PLATFORM = "mercari"

      def self.validate_query(_uri); end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_mercari_page(uri))
        results = mercari_results(page)
        if results.empty?
          empty = page.at_css(".merEmptyState")
          raise "Search page has no extractable listings" unless empty && !empty.text.strip.empty?
        end
        results
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
