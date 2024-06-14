module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingExcludeKeyword
        class CreateYahooAuctionCrawlSettingExcludeKeywordResult < Base
          possible_types Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
                         CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                         Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
                         CreateYahooAuctionCrawlSettingExcludeKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
              Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
              CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess
            when "CreateYahooAuctionCrawlSettingExcludeKeywordResultError"
              Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
              CreateYahooAuctionCrawlSettingExcludeKeywordResultError
            else
              raise "Unexpected CreateYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
