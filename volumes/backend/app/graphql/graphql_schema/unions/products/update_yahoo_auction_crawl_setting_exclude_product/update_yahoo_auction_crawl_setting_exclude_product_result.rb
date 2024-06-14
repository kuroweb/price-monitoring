module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeProduct
        class UpdateYahooAuctionCrawlSettingExcludeProductResult < Base
          possible_types Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
                         UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess,
                         Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
                         UpdateYahooAuctionCrawlSettingExcludeProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
              UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess
            when "UpdateYahooAuctionCrawlSettingExcludeProductResultError"
              Objects::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
              UpdateYahooAuctionCrawlSettingExcludeProductResultError
            else
              raise "Unexpected UpdateYahooAuctionCrawlSettingExcludeProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
