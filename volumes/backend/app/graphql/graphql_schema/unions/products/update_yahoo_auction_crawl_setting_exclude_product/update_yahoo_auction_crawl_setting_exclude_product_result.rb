module GraphqlSchema
  module Unions
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeProduct
        class UpdateYahooAuctionCrawlSettingExcludeProductResult < Base
          possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                         UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess,
                         Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                         UpdateYahooAuctionCrawlSettingExcludeProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess"
              Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
              UpdateYahooAuctionCrawlSettingExcludeProductResultSuccess
            when "UpdateYahooAuctionCrawlSettingExcludeProductResultError"
              Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
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
