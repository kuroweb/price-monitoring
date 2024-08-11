module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeKeyword
          class DeleteYahooAuctionCrawlSettingExcludeKeywordResult < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                           DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                           DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccessType
              when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrorType
              else
                raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
