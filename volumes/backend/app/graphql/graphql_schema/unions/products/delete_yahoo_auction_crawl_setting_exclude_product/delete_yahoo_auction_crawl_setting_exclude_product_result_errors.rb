module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeProduct
        class DeleteYahooAuctionCrawlSettingExcludeProductResultErrors < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
                         DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
              DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
