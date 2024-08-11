module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeProduct
          class DeleteYahooAuctionCrawlSettingExcludeProductResultUnion < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                           DeleteYahooAuctionCrawlSettingExcludeProductResultSuccessType,
                           Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                           DeleteYahooAuctionCrawlSettingExcludeProductResultErrorType

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingExcludeProductResultSuccessType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                DeleteYahooAuctionCrawlSettingExcludeProductResultSuccessType
              when "DeleteYahooAuctionCrawlSettingExcludeProductResultErrorType"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                DeleteYahooAuctionCrawlSettingExcludeProductResultErrorType
              else
                raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeProductResultUnion: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
