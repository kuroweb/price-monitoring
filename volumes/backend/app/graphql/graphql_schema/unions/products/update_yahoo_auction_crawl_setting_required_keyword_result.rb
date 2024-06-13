module GraphqlSchema
  module Unions
    module Products
      class UpdateYahooAuctionCrawlSettingRequiredKeywordResult < Base
        possible_types Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                       Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingRequiredKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingRequiredKeywordResultSuccess
          when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultError"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingRequiredKeywordResultError
          else
            raise "Unexpected UpdateYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
