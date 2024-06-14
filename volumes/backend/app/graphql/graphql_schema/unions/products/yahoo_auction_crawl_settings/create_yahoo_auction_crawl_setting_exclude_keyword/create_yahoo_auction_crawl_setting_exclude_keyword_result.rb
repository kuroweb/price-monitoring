module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeKeyword
          class CreateYahooAuctionCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                           CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                           Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                           CreateYahooAuctionCrawlSettingExcludeKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess
              when "CreateYahooAuctionCrawlSettingExcludeKeywordResultError"
                Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                CreateYahooAuctionCrawlSettingExcludeKeywordResultError
              else
                raise "Unexpected CreateYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
