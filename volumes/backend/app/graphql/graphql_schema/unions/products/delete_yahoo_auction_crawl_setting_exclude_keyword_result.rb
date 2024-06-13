module GraphqlSchema
  module Unions
    module Products
      class DeleteYahooAuctionCrawlSettingExcludeKeywordResult < Base
        possible_types Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                       Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingExcludeKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess
          when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultError"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingExcludeKeywordResultError
          else
            raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
