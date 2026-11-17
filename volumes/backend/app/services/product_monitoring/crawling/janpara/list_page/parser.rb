module ProductMonitoring
  module Crawling
    module Janpara
      module ListPage
        # 検索結果1ページを解析し、出品と次ページのURLを返す
        class Parser
          def self.call(...)
            new(...).call
          end

          def initialize(uri, page)
            @uri = uri
            @page = page
          end

          def call
            results = page.css(".search_item_s").filter_map do |dom|
              id = listing_id(dom)
              listing(dom, id) if id
            end
            raise "Search page has no extractable listings" if results.empty? && !page.at_css(".sorry")

            [results, next_url]
          end

          private

          attr_reader :uri, :page

          # 商品グループの SRCODE または ITMCODE を出品IDにする
          def listing_id(dom)
            link = detail_link(dom)
            return unless link

            URI.decode_www_form(link.query.to_s).find do |key, value|
              %w[SRCODE ITMCODE].include?(key) && value.match?(/\A\d+\z/)
            end&.join("=")
          end

          def detail_link(dom)
            href = dom.at_css(".search_itemlink")&.[]("href")
            return unless href

            link = URI.join("https://#{SearchUrl::HOST}", href)
            link if link.host == SearchUrl::HOST && link.path == "/sale/search/detail/"
          end

          def listing(dom, id)
            name = dom.at_css(".search_itemname")&.text.to_s.strip.gsub(/\R/, "")
            raise "Listing name is missing" if name.empty?

            image = dom.at_css("img")&.[]("src")
            { platform: SearchUrl::PLATFORM, external_id: id, name: name, price: price(dom),
              product_url: "https://#{SearchUrl::HOST}/sale/search/detail/?#{id}",
              thumbnail_url: image.present? ? URI.join("https://#{SearchUrl::HOST}", image).to_s : nil,
              sold: dom.at_css(".search_nostock").present? }
          end

          # 商品グループの下限価格を価格にする。DBの整数の上限を超える値は価格なしとする
          def price(dom)
            amounts = dom.css(".item_amount")
            return if amounts.size > 2

            amount = amounts.size == 2 ? amounts[1] : amounts[0]
            match = amount&.text.to_s.strip.sub(/～\z/, "").match(/\A[¥￥]?\s*(\d[\d,]*)\s*(?:円)?\s*(?:\(税込\))?\z/)
            value = match && match[1].delete(",").to_i
            value if value && value <= ProductMonitoring::CrawlResult::MAX_PRICE
          end

          def next_url
            return unless page.at_css(".pageLink[title='次ページ']")

            uri.dup.tap { |next_uri| next_uri.query = next_query }
          end

          def next_query
            query = URI.decode_www_form(uri.query)
            number = query.to_h.fetch("PAGE", "1").to_i
            query.reject! { |name, _| name == "PAGE" }
            query << ["PAGE", [number + 1, 2].max.to_s]
            URI.encode_www_form(query)
          end
        end
      end
    end
  end
end
