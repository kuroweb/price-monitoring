module GraphqlSchema
  module Unions
    module Products
      class DeleteYahooAuctionCrawlSettingRequiredKeywordResult < Base
        possible_types Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                       Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingRequiredKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess
          when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultError"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingRequiredKeywordResultError
          else
            raise "Unexpected DeleteYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
