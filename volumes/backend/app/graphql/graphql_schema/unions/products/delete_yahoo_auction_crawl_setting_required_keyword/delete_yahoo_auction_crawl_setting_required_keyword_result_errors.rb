module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingRequiredKeyword
        class DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                         DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed"
              Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
              DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
