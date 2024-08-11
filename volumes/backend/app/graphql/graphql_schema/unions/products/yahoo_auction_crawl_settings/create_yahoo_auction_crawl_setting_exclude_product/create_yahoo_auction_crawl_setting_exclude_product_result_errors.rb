module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeProduct
          class CreateYahooAuctionCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                           CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType
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
