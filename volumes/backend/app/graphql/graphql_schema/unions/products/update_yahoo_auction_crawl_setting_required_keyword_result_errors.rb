module GraphqlSchema
  module Unions
    module Products
      class UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::\
                       UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
