module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeKeyword
        class DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                         DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
              DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
