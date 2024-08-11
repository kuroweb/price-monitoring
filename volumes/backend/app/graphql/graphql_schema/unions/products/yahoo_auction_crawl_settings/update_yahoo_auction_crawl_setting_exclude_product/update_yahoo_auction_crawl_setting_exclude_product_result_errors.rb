module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeProduct
          class UpdateYahooAuctionCrawlSettingExcludeProductResultErrors < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                           UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailedType
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
