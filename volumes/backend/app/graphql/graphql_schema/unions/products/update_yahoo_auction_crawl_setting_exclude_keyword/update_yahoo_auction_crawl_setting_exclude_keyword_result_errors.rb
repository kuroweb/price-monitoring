module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeKeyword
        class UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                         UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
              UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
