module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResult < Base
          possible_types Objects::Products::CreateYahooAuctionCrawlSettingExcludeProduct::
                         CreateYahooAuctionCrawlSettingExcludeProductResultSuccess,
                         Objects::Products::CreateYahooAuctionCrawlSettingExcludeProduct::
                         CreateYahooAuctionCrawlSettingExcludeProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingExcludeProductResultSuccess"
              Objects::Products::CreateYahooAuctionCrawlSettingExcludeProduct::
              CreateYahooAuctionCrawlSettingExcludeProductResultSuccess
            when "CreateYahooAuctionCrawlSettingExcludeProductResultError"
              Objects::Products::CreateYahooAuctionCrawlSettingExcludeProduct::
              CreateYahooAuctionCrawlSettingExcludeProductResultError
            else
              raise "Unexpected CreateYahooAuctionCrawlSettingExcludeProductResult: #{object}"
            end
          end
        end
      end
    end
  end
end
