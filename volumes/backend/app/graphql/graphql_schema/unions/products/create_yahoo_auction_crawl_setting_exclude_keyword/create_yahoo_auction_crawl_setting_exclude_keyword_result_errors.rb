module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingExcludeKeyword
        class CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors < Base
          possible_types Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
                         CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed"
              Objects::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
              CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
