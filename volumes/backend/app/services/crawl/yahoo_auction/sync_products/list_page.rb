# 一覧画面の DOM 取得・パース（開催中 / 落札相場で共通）
module Crawl
  module YahooAuction
    module SyncProducts
      module ListPage # rubocop:disable Metrics/ModuleLength -- 一覧 DOM パースの共通モジュール
        PRODUCT_ITEM_SELECTOR = 'li:has(> div a[href*="jp/auction/"])'.freeze
        TITLE_LINK_SELECTOR = 'a[href*="jp/auction/"].wb_break-all'.freeze
        SELLER_LINK_SELECTOR = 'a[href*="/seller/"]'.freeze
        PRICE_SECTION_SELECTOR = '[class*="lg:grid-tc_1fr_160px"]'.freeze
        NEXT_PAGE_SELECTOR = "a >> text=次へ".freeze
        LIST_LOAD_WAIT_SECONDS = 3
        END_TIME_PATTERN = %r{(\d{1,2}/\d{1,2})\s+(\d{1,2}:\d{2})終了}
        REMAINING_TIME_ONLY_PATTERN = /\A(?:(\d+)時間)?(?:(\d+)分)?(?:(\d+)秒)\z/

        module_function

        def product_items(page)
          page.query_selector_all(PRODUCT_ITEM_SELECTOR)
        end

        def wait_for_list(_page)
          sleep(LIST_LOAD_WAIT_SECONDS)
        end

        def not_exist_results?(page)
          page.query_selector(".Notice__wandQuery") ||
            page.query_selector("text=条件に一致する商品は見つかりませんでした")
        end

        def not_exist_next_page?(page)
          page.query_selector(NEXT_PAGE_SELECTOR).nil?
        end

        def not_crawlable?(dom)
          title_link(dom).nil? || dom.query_selector(SELLER_LINK_SELECTOR).nil?
        end

        def assert_first_page_products!(page, first_page:, items_count:, crawlable_count:, added_count:)
          return unless first_page
          return if not_exist_results?(page)

          return unless items_count.zero? || (crawlable_count.positive? && added_count.zero?)

          raise ProductListHtmlMismatchError,
                "商品一覧の HTML を解釈できず 0 件のまま成功扱いになる状態です"
        end

        def external_id(dom)
          href = title_link(dom).get_attribute("href")
          href.split("/").last
        end

        def seller_id(dom)
          href = dom.query_selector(SELLER_LINK_SELECTOR).get_attribute("href")
          href[%r{seller/([^/?#]+)}, 1]
        end

        def name(dom)
          title_link(dom).inner_text
        end

        def thumbnail_url(dom)
          img = dom.query_selector("img")
          src = img&.get_attribute("src")
          return src if src.present?

          srcset = img&.get_attribute("srcset")
          return srcset.split(",").first.strip.split.first if srcset.present?

          data_src = img&.get_attribute("data-src")
          return data_src if data_src.present?

          nil
        end

        def title_link(dom)
          dom.query_selector(TITLE_LINK_SELECTOR) || dom.query_selector('a[href*="jp/auction/"]')
        end

        def published_prices(dom)
          text = price_section_text(dom)
          current = text[/現在([\d,]+)円/, 1]
          buyout = text[/即決([\d,]+)円/, 1]

          if current
            [current.delete(",").to_i, buyout&.delete(",")&.to_i]
          elsif buyout
            [buyout.delete(",").to_i, nil]
          end
        end

        def closed_price(dom)
          text = price_section_text(dom)
          matched = text[/落札([\d,]+)円/, 1]
          matched&.delete(",")&.to_i
        end

        def auction_end_datetime(dom, mode: :published)
          text = dom.inner_text
          matched = text.match(END_TIME_PATTERN)
          if matched
            datetime = Time.zone.parse("#{Time.current.year}/#{matched[1]} #{matched[2]}")
            return adjust_year(datetime, mode:) if datetime
          end

          remaining_seconds = remaining_seconds_from_dom(dom)
          return Time.current + remaining_seconds.seconds if remaining_seconds&.positive?

          nil
        end

        def remaining_seconds_from_dom(dom)
          dom.query_selector_all("span").each do |element|
            span_text = element.inner_text.strip
            next if span_text.blank?

            remaining = span_text.match(REMAINING_TIME_ONLY_PATTERN)
            next unless remaining

            hours, minutes, seconds = remaining.captures.map(&:to_i)
            total = (hours * 3600) + (minutes * 60) + seconds
            return total if total.positive?
          end

          nil
        end

        def adjust_year(datetime, mode:)
          return unless datetime

          case mode
          when :published
            datetime += 1.year if datetime < 1.day.ago
          when :unpublished
            datetime -= 1.year if datetime > 1.day.from_now
          end

          datetime
        end

        def price_section_text(dom)
          dom.query_selector(PRICE_SECTION_SELECTOR)&.inner_text || dom.inner_text
        end
      end # rubocop:enable Metrics/ModuleLength
    end
  end
end
