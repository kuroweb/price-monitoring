module ProductMonitoring
  module Crawling
    module Mercari
      module ListPage
        # 検索結果1ページを解析し、出品と次ページのURLを返す
        class Parser
          def self.call(...)
            new(...).call
          end

          def initialize(uri, page, seller_ids = {})
            @uri = uri
            @page = page
            @seller_ids = seller_ids
          end

          def call
            results = page.css("li[data-testid='item-cell']").filter_map do |dom|
              id = listing_id(dom)
              listing(dom, id) if id
            end
            empty_state = page.at_css(".merEmptyState")
            raise "Search page has no extractable listings" if results.empty? && empty_state&.text.blank?

            [results, next_url]
          end

          private

          attr_reader :uri, :page, :seller_ids

          def listing_id(dom)
            href = dom.at_css("a")&.[]("href")
            href&.match(%r{/item/([^/?]+)})&.[](1)
          end

          def listing(dom, id)
            name = dom.at_css("[data-testid='thumbnail-item-name']")&.text.to_s.strip
            raise "Listing name is missing" if name.empty?

            # 既存のメルカリクローラーと同じく、画像URLは external_id から組み立てる
            { platform: SearchUrl::PLATFORM, external_id: id, name: name,
              price: price(dom.at_css("[data-testid='item-tile-price']")&.text),
              product_url: "https://#{SearchUrl::HOST}/item/#{id}",
              thumbnail_url: "https://static.mercdn.net/thumb/item/webp/#{id}_1.jpg",
              sold: dom.at_css("img[alt$='売り切れ']").present?, seller_id: seller_ids[id] }
          end

          # 「¥1,200」などの表示価格を整数にする。DBの整数の上限を超える値は価格なしとする
          def price(text)
            match = text.to_s.strip.match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductMonitoring::CrawlResult::MAX_PRICE
          end

          def next_url
            return unless page.at_css("[data-testid='pagination-next-button']")

            uri.dup.tap { |next_uri| next_uri.query = next_query }
          end

          def next_query
            query = URI.decode_www_form(uri.query)
            current = query.to_h.fetch("page_token", "v1:0").delete_prefix("v1:").to_i
            query.reject! { |key, _| key == "page_token" }
            query << ["page_token", "v1:#{current + 1}"]
            URI.encode_www_form(query)
          end
        end
      end
    end
  end
end
