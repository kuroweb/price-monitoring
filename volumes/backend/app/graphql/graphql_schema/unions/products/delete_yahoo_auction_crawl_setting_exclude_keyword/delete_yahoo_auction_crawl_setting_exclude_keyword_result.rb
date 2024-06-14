module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeKeyword
        class DeleteYahooAuctionCrawlSettingExcludeKeywordResult < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                         DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                         Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                         DeleteYahooAuctionCrawlSettingExcludeKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
              DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess
            when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultError"
              Objects::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
              DeleteYahooAuctionCrawlSettingExcludeKeywordResultError
            else
              raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
