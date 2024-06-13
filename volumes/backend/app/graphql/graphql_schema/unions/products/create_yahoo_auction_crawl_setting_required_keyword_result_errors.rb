module GraphqlSchema
  module Unions
    module Products
      class CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::\
                       CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed"
            Objects::Products::MutationResults::CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
