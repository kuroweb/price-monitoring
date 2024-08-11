module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingRequiredKeyword
          class CreateYahooAuctionCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                           CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType
              else
                raise "Unexpected error type: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
