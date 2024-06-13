module GraphqlSchema
  module Unions
    module Products
      class CreateYahooAuctionCrawlSettingExcludeKeywordResult < Base
        possible_types Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                       Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingExcludeKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingExcludeKeywordResultSuccess
          when "CreateYahooAuctionCrawlSettingExcludeKeywordResultError"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingExcludeKeywordResultError
          else
            raise "Unexpected CreateYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
