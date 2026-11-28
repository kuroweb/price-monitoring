module ProductMonitoring
  module Crawling
    module YahooFleamarket
      module ListPage
        # 一覧に埋め込まれた検索結果のデータから、出品IDと出品者IDの組を読む。
        # データが無い、形が違うといった場合は出品者IDを不明とし、一覧の取得は続ける
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
