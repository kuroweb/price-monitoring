module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingRequiredKeyword
        class UpdateYahooAuctionCrawlSettingRequiredKeywordResult < Base
          possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                         UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                         Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                         UpdateYahooAuctionCrawlSettingRequiredKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
              Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
              UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess
            when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultError"
              Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
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
