module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeKeyword
          class CreateYahooAuctionCrawlSettingExcludeKeywordResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                           CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                           CreateYahooAuctionCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccessType
              when "CreateYahooAuctionCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                CreateYahooAuctionCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected CreateYahooAuctionCrawlSettingExcludeKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
