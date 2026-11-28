module ProductMonitoring
  module Crawling
    module YahooAuction
      module ListPage
        # 出品中・落札相場の一覧に埋め込まれた検索結果のデータから、出品IDと出品者IDの組を読む。
        # データが無い、形が違うといった場合は出品者IDを不明とし、一覧の解析は続ける
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
