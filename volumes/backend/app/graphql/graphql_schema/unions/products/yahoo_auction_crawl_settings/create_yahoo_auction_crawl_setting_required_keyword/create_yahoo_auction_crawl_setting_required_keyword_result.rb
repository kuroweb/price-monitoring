module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingRequiredKeyword
          class CreateYahooAuctionCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                           CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                           CreateYahooAuctionCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType
              when "CreateYahooAuctionCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                CreateYahooAuctionCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected CreateYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
