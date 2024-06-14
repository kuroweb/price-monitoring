module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeProduct
          class DeleteYahooAuctionCrawlSettingExcludeProductResult < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                           DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess,
                           Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                           DeleteYahooAuctionCrawlSettingExcludeProductResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess
              when "DeleteYahooAuctionCrawlSettingExcludeProductResultError"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                DeleteYahooAuctionCrawlSettingExcludeProductResultError
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
