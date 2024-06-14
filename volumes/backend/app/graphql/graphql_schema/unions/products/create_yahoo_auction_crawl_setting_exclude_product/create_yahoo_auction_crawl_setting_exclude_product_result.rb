module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResult < Base
          possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                         CreateYahooAuctionCrawlSettingExcludeProductResultSuccess,
                         Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                         CreateYahooAuctionCrawlSettingExcludeProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingExcludeProductResultSuccess"
              Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
              CreateYahooAuctionCrawlSettingExcludeProductResultSuccess
            when "CreateYahooAuctionCrawlSettingExcludeProductResultError"
              Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
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
