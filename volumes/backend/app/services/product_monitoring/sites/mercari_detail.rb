module ProductMonitoring
  module Sites
    module MercariDetail
      DELETED_TEXTS = ["ページが見つかりませんでした", "該当する商品は削除されています。"].freeze

      def deleted_detail?(page)
        return false if page.at_css("[data-testid='item-detail-container']")

        page.at_css(".merEmptyState") || DELETED_TEXTS.any? { |text| page.text.include?(text) }
      end

      def detail_sold(page)
        states = { "https://schema.org/SoldOut" => true, "https://schema.org/InStock" => false }
        page.css("script[type='application/ld+json']").each do |script|
          json_ld_products(script).each do |product|
            next unless product.is_a?(Hash) && product["@type"] == "Product"

            availability = product["offers"].is_a?(Hash) && product["offers"]["availability"]
            result = states[availability]
            return result unless result.nil?
          end
        end
        nil
      end

      def json_ld_products(script)
        data = JSON.parse(script.text)
        data = data["@graph"] if data.is_a?(Hash) && data["@graph"].is_a?(Array)
        data.is_a?(Array) ? data : [data]
      rescue JSON::ParserError
        []
      end

      def detail_bought_date(page)
        text = page.at_css("[data-testid='item-detail-container'] div[aligncontent='start']:has(svg)")&.text&.strip
        return unless text && text.length < 20

        parse_detail_date(text)
      end

      def parse_detail_date(text)
        case text
        when /\A\d+(?:分前|時間前)\z/ then Time.current.beginning_of_day
        when /\A(\d+)日前\z/ then Time.current.days_ago(Regexp.last_match(1).to_i).beginning_of_day
        when /\A(\d+)か月前\z/ then Time.current.months_ago(Regexp.last_match(1).to_i).beginning_of_day
        when "半年以上前" then Time.current.months_ago(6).beginning_of_day
        end
      end
    end
  end
end
