# Yahoo!フリマ（PayPayフリマ）の検索結果 1 行分の DOM から商品情報を取り出す
module Crawl
  module YahooFleamarket
    module SyncProducts
      module ListItem
        ITEM_LINK_SUBSTRING = "paypayfleamarket.yahoo.co.jp/item/".freeze

        module_function

        def product_doms(page)
          seen = {}
          page.query_selector_all("li").filter_map do |item|
            next unless crawlable?(item)

            external_id = external_id(item)
            next if seen[external_id]

            seen[external_id] = true
            item
          end
        end

        def crawlable?(item)
          title_link(item).present? && price_text(item).present? && item.query_selector("img").present?
        end

        def title_link(item)
          item.query_selector_all("a[href*=\"#{ITEM_LINK_SUBSTRING}\"]").find do |link|
            link.inner_text.strip.present?
          end
        end

        def external_id(item)
          href = title_link(item).get_attribute("href")
          href.split("/").last
        end

        def seller_id(item)
          href = item.query_selector('a[href*="/user/"]')&.get_attribute("href")
          href&.match(%r{user/([^/]+)})&.[](1)
        end

        def name(item)
          title_link(item).inner_text.strip
        end

        def price(item)
          price_text(item).delete(",")
        end

        def price_text(item)
          item.query_selector_all("span").each do |span|
            text = span.inner_text.strip
            next if (m = text.match(/\A(?:即決|落札)?([\d,]+)円\z/)).nil?

            return m[1]
          end

          item.inner_text.match(/([\d,]+)円/)&.[](1).to_s
        end

        def thumbnail_url(item)
          img = product_link_image(item) || item.query_selector("img")
          img.get_attribute("src")
        end

        def product_link_image(item)
          item.query_selector_all("a[href*=\"#{ITEM_LINK_SUBSTRING}\"]").each do |link|
            img = link.query_selector("img")
            return img if img
          end

          nil
        end

        def bought_date(item)
          date_str = item.inner_text.match(%r{(\d{1,2}/\d{1,2}\s\d{1,2}:\d{2})終了})&.[](1)
          return nil if date_str.blank?

          datetime = Time.zone.parse(date_str)
          datetime > Time.current ? datetime.ago(1.year) : datetime
        end

        def next_page?(page, start)
          target = start + 100
          pattern = /[?&]b=#{target}(?:&|\z)/
          page.query_selector_all('a[href*="b="]').any? do |link|
            link.get_attribute("href").to_s.match?(pattern)
          end
        end
      end
    end
  end
end
