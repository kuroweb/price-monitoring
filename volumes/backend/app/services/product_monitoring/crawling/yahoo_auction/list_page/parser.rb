module ProductMonitoring
  module Crawling
    module YahooAuction
      module ListPage
        # 出品中・落札相場の検索結果1ページを解析し、出品と次ページのURLを返す
        class Parser
          PRODUCT_SELECTOR = 'li:has(> div a[href*="jp/auction/"])'.freeze
          TITLE_SELECTOR = 'a[href*="jp/auction/"].wb_break-all'.freeze
          PRICE_SELECTOR = '[class*="lg:grid-tc_1fr_160px"]'.freeze
          END_TIME_PATTERN = %r{(\d{1,2}/\d{1,2})\s+(\d{1,2}:\d{2})終了}
          REMAINING_TIME_PATTERN = /\A(?:(\d+)時間)?(?:(\d+)分)?(?:(\d+)秒)\z/

          def self.call(...)
            new(...).call
          end

          def initialize(uri, page)
            @uri = uri
            @page = page
            @closed = uri.path.start_with?("/closedsearch")
          end

          def call
            return [[], nil] if page.at_css(".Notice__wandQuery") ||
                                page.text.include?("条件に一致する商品は見つかりませんでした")

            results = page.css(PRODUCT_SELECTOR).filter_map { |item| listing(item) }
            raise "Search page has no extractable listings" if results.empty?

            [results, next_url]
          end

          private

          attr_reader :uri, :page, :closed

          def listing(item)
            title = item.at_css(TITLE_SELECTOR) || item.at_css('a[href*="jp/auction/"]')
            return unless title && item.at_css('a[href*="/seller/"]')

            price, buyout = prices(item)
            id = auction_id(title)
            return if price.nil? || id.nil?

            { platform: SearchUrl::PLATFORM, external_id: id, name: title.text.strip, price: price,
              buyout_price: buyout, product_url: "https://#{SearchUrl::HOST}/jp/auction/#{id}",
              thumbnail_url: thumbnail_url(item), seller_id: seller_ids[id] }.merge(sale(item))
          end

          def seller_ids
            @seller_ids ||= SellerIds.call(page)
          end

          def auction_id(title)
            id = title["href"].to_s.split("/").last.to_s
            id if id.match?(/\A[a-zA-Z0-9_-]+\z/)
          end

          # 落札相場の出品は終了日時を売れた日にする
          def sale(item)
            ends_at = end_datetime(item)
            { sold: closed, sold_at: closed ? ends_at : nil, ends_at: }
          end

          # 出品中は現在価格と即決価格、落札相場は落札価格を返す。即決だけの出品は即決価格を価格にする
          def prices(item)
            text = (item.at_css(PRICE_SELECTOR) || item).text.gsub(/\s+/, "")
            current = text[closed ? /落札([\d,]+)円/ : /現在([\d,]+)円/, 1]
            buyout = closed ? nil : text[/即決([\d,]+)円/, 1]
            return [number(current), number(buyout)] if current
            return [number(buyout), nil] if buyout

            [nil, nil]
          end

          def number(value)
            value&.delete(",")&.to_i
          end

          def thumbnail_url(item)
            image = item.at_css("img")
            return if image.nil?

            return image["src"] if image["src"].present?
            return image["srcset"].split(",").first.strip.split.first if image["srcset"].present?

            image["data-src"].presence
          end

          def end_datetime(item)
            matched = item.css("span").reverse_each.filter_map { |span| span.text.match(END_TIME_PATTERN) }.first
            datetime = parse_end_datetime(matched) if matched
            return datetime if datetime

            remaining_datetime(item)
          end

          def parse_end_datetime(matched)
            datetime = Time.zone.parse("#{Time.current.year}/#{matched[1]} #{matched[2]}")
            return if datetime.nil?

            adjust_year(datetime)
          end

          # 一覧の終了日時には年が無い。今年として読んだ日時が、終了済みなのに未来、出品中なのに過去なら年をまたいでいる
          def adjust_year(datetime)
            if closed
              datetime > 1.day.from_now ? datetime - 1.year : datetime
            else
              datetime < 1.day.ago ? datetime + 1.year : datetime
            end
          end

          def remaining_datetime(item)
            item.css("span").each do |span|
              remaining = span.text.strip.match(REMAINING_TIME_PATTERN)
              next unless remaining

              hours, minutes, seconds = remaining.captures.map(&:to_i)
              total = (hours * 3600) + (minutes * 60) + seconds
              return Time.current + total.seconds if total.positive?
            end
            nil
          end

          # 開始位置 b を1ページ分の100件だけ進める
          def next_url
            return unless page.css("a").any? { |link| link.text.include?("次へ") }

            query = URI.decode_www_form(uri.query)
            uri_with_start(query, query.to_h.fetch("b", "1").to_i + 100)
          end

          def uri_with_start(query, start)
            query.reject! { |name, _| name == "b" }
            uri.dup.tap { |next_uri| next_uri.query = URI.encode_www_form(query << ["b", start.to_s]) }
          end
        end
      end
    end
  end
end
