module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingRequiredKeyword
        class UpdateYahooAuctionCrawlSettingRequiredKeywordResult < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                         UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                         Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                         UpdateYahooAuctionCrawlSettingRequiredKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
              Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
              UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess
            when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultError"
              Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
              UpdateYahooAuctionCrawlSettingRequiredKeywordResultError
            else
              raise "Unexpected UpdateYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
