module ProductMonitoring
  module Crawling
    module YahooAuction
      module ListPage
        module SellerIds
          def self.call(page)
            data = JSON.parse(page.at_css('script#__NEXT_DATA__[type="application/json"]')&.text.to_s)
            items = data.dig("props", "initialState", "search", "items", "listing", "items")
            return {} unless items.is_a?(Array)

            SellerIdMap.build(items.filter_map { |item| pair(item) })
          rescue JSON::ParserError, TypeError, NoMethodError
            {}
          end

          def self.pair(item)
            return unless item.is_a?(Hash)

            seller = item["seller"]
            [item["auctionId"], seller.is_a?(Hash) ? seller["userId"] : nil]
          end
          private_class_method :pair
        end
      end
    end
  end
end
