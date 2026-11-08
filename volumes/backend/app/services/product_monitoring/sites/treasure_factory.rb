require "nokogiri"

module ProductMonitoring
  module Sites
    class TreasureFactory
      HOST = "ec.treasure-f.com".freeze
      PATH = %r{\A/search/?\z}
      PLATFORM = "treasure_factory".freeze
      MAX_RESPONSE_BYTES = 10 * 1024 * 1024

      def self.search_urls(keyword)
        ["https://#{HOST}/search?#{URI.encode_www_form(word: keyword)}"]
      end

      def self.validate_query(uri)
        raise ArgumentError, "URL query is required" if uri.query.to_s.empty?
      end

      def self.fetch(uri)
        page = Nokogiri::HTML(fetch_page(uri))
        results = listings(page)
        # 売り切れだけのページは出品があっても結果が空になる
        if results.empty? && !page.at_css("li.pj-search_item, .pj-search_not_found")
          raise "Search page has no extractable listings"
        end

        [results, next_url(uri, page)]
      end

      def self.fetch_page(uri)
        BrowserPage.fetch(uri, host: HOST, max_bytes: MAX_RESPONSE_BYTES)
      end

      def self.next_url(uri, page)
        return unless page.at_css(".cm-pagination a[rel='next']")

        Pagination.increment(uri, key: "page", default: "1", step: 1, minimum: 2)
      end

      # 売り切れの出品は一覧に価格がないので、販売中の出品だけを返す
      def self.listings(page)
        Crawler.listing_nodes(page, "li.pj-search_item").filter_map do |dom|
          href = dom.at_css("a.cm-itemlist_itemcode_link")&.[]("href")
          id = href&.match(%r{\A/item/(\d+)\z})&.[](1)
          next unless id && !dom.at_css(".cm-itemlist_soldout")

          listing(dom, id)
        end
      end

      def self.listing(dom, id)
        image = dom.at_css(".cm-itemlist_image img")
        name = listing_name(dom, image)
        raise "Listing name is missing" if name.blank?

        { external_id: id, name: name, price: Crawler.parse_price(dom.at_css(".cm-itemlist_price")&.text),
          product_url: "https://#{HOST}/item/#{id}", thumbnail_url: thumbnail_url(image), sold: false }
      end

      # 画像の代替テキストはブランド名と型番を含み、個別ページの商品名と一致する
      def self.listing_name(dom, image)
        image&.[]("alt").to_s.strip.presence || dom.css(".cm-itemlist_text").map { |p| p.text.strip }.join(" ")
      end

      def self.thumbnail_url(image)
        image_url = image&.[]("data-src").presence || image&.[]("src")
        image_url.present? ? URI.join("https://#{HOST}", image_url).to_s : nil
      end
    end
  end
end
