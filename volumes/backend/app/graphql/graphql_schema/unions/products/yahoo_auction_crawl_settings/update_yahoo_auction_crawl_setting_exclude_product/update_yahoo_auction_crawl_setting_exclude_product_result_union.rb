module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeProduct
          class UpdateYahooAuctionCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                           UpdateYahooAuctionCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                           UpdateYahooAuctionCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateYahooAuctionCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                UpdateYahooAuctionCrawlSettingExcludeProductResultSuccessType
              when "UpdateYahooAuctionCrawlSettingExcludeProductResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                UpdateYahooAuctionCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected UpdateYahooAuctionCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
