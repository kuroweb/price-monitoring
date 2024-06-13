module GraphqlSchema
  module Unions
    module Products
      class DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::\
                       DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
