module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeProduct
          class CreateYahooAuctionCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                           CreateYahooAuctionCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                           CreateYahooAuctionCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                CreateYahooAuctionCrawlSettingExcludeProductResultSuccessType
              when "CreateYahooAuctionCrawlSettingExcludeProductResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                CreateYahooAuctionCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected CreateYahooAuctionCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
