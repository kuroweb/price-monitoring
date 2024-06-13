module GraphqlSchema
  module Unions
    module Products
      class CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::\
                       CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
