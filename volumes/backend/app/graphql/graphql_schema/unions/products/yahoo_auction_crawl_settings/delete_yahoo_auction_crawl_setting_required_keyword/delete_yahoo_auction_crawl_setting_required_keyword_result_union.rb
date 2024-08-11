module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingRequiredKeyword
          class DeleteYahooAuctionCrawlSettingRequiredKeywordResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                           DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                           DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccessType
              when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrorType
              else
                raise "Unexpected DeleteYahooAuctionCrawlSettingRequiredKeywordResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
