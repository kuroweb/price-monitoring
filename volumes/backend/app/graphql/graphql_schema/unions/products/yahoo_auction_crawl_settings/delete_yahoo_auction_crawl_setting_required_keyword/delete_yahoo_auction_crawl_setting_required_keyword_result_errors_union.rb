module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingRequiredKeyword
          class DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrorsUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                           DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailedType
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
