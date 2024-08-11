module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeKeyword
          class UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                           UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType
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
