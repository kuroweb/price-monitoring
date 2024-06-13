module GraphqlSchema
  module Unions
    module Products
      class CreateYahooAuctionCrawlSettingRequiredKeywordResult < Base
        possible_types Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                       Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingRequiredKeywordResultError

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingRequiredKeywordResultSuccess
          when "CreateYahooAuctionCrawlSettingRequiredKeywordResultError"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingRequiredKeywordResultError
          else
            raise "Unexpected CreateYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
          end
        end
      end
    end
  end
end
