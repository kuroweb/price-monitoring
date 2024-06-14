module GraphqlSchema
  module Unions
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResultErrors < Base
          possible_types Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                         CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailed

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailed"
              Objects::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
              CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailed
            else
              raise "Unexpected error type: #{object}"
            end
          end
        end
      end
    end
  end
end
