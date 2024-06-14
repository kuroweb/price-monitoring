module GraphqlSchema
  module Unions
    module Products
      class DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::
                       DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
            Objects::Products::MutationResults::DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
