module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingRequiredKeyword
        class CreateYahooAuctionCrawlSettingRequiredKeywordResult < Base
          possible_types Objects::Products::CreateYahooAuctionCrawlSettingRequiredKeyword::
                         CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                         Objects::Products::CreateYahooAuctionCrawlSettingRequiredKeyword::
                         CreateYahooAuctionCrawlSettingRequiredKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
              Objects::Products::CreateYahooAuctionCrawlSettingRequiredKeyword::
              CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess
            when "CreateYahooAuctionCrawlSettingRequiredKeywordResultError"
              Objects::Products::CreateYahooAuctionCrawlSettingRequiredKeyword::
              CreateYahooAuctionCrawlSettingRequiredKeywordResultError
            else
              raise "Unexpected CreateYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
