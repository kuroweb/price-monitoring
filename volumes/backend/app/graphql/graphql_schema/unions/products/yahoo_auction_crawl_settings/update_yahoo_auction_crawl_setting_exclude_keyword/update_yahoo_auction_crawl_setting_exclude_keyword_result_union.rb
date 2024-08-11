module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeKeyword
          class UpdateYahooAuctionCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                           UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                           UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType
              when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected UpdateYahooAuctionCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
