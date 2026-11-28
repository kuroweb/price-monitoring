module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module ListPage
        module SellerIds
          def self.call(page)
            data = JSON.parse(page.at_css('script#__NEXT_DATA__[type="application/json"]')&.text.to_s)
            items = data.dig("props", "initialState", "searchState", "search", "result", "items")
            return {} unless items.is_a?(Array)

            SellerIdMap.build(items.filter_map { |item| [item["id"], item["sellerId"]] if item.is_a?(Hash) })
          rescue JSON::ParserError, TypeError, NoMethodError
            {}
          end
        end
      end
    end
  end
end
