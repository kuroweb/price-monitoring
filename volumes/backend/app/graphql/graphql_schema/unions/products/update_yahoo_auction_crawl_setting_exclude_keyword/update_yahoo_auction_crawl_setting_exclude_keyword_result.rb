module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeKeyword
        class UpdateYahooAuctionCrawlSettingExcludeKeywordResult < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                         UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                         Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                         UpdateYahooAuctionCrawlSettingExcludeKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
              UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess
            when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultError"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
              UpdateYahooAuctionCrawlSettingExcludeKeywordResultError
            else
              raise "Unexpected UpdateYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
