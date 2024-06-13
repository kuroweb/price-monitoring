module GraphqlSchema
  module Unions
    module Products
      class UpdateYahooAuctionCrawlSettingExcludeKeywordResult < Base
        possible_types Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                       Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingExcludeKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingExcludeKeywordResultSuccess
          when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultError"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingExcludeKeywordResultError
          else
            raise "Unexpected UpdateYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
