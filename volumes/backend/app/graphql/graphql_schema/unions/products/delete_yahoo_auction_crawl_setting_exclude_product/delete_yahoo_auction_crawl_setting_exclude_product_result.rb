module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeProduct
        class DeleteYahooAuctionCrawlSettingExcludeProductResult < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
                         DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess,
                         Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
                         DeleteYahooAuctionCrawlSettingExcludeProductResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
              DeleteYahooAuctionCrawlSettingExcludeProductResultSuccess
            when "DeleteYahooAuctionCrawlSettingExcludeProductResultError"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
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
