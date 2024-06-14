module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingRequiredKeyword
        class UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                         UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed"
              Objects::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
              UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
