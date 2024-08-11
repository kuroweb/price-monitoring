module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeProduct
          class DeleteYahooAuctionCrawlSettingExcludeProductResult < Base
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
                raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeProductResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
