module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeKeyword
          class DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrorsUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                           DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailedType
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
