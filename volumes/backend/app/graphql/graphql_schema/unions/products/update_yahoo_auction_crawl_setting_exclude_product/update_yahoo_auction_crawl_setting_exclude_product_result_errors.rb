module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeProduct
        class UpdateYahooAuctionCrawlSettingExcludeProductResultErrors < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
                         UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailed"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
              UpdateYahooAuctionCrawlSettingExcludeProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
