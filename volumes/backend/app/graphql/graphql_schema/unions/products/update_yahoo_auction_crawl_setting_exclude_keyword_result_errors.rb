module GraphqlSchema
  module Unions
    module Products
      class UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
        possible_types Objects::Products::MutationResults::\
                       UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

        def self.resolve_type(object, _context)
          case object[:__typename]
          when "UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
            Objects::Products::MutationResults::UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
          else
            raise "Unexpected error type: #{object}"
          end
        end
      end
    end
  end
end
