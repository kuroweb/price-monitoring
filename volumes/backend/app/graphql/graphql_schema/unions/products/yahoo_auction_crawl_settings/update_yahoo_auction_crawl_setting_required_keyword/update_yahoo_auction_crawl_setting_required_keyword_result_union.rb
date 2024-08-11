module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingRequiredKeyword
          class UpdateYahooAuctionCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                           UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                           UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccessType
              when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected UpdateYahooAuctionCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
