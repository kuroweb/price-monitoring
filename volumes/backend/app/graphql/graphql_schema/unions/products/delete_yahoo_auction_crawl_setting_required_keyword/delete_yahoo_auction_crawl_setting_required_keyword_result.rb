module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingRequiredKeyword
        class DeleteYahooAuctionCrawlSettingRequiredKeywordResult < Base
          possible_types Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                         DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                         Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                         DeleteYahooAuctionCrawlSettingRequiredKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
              Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
              DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess
            when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultError"
              Objects::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
              DeleteYahooAuctionCrawlSettingRequiredKeywordResultError
            else
              raise "Unexpected DeleteYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
