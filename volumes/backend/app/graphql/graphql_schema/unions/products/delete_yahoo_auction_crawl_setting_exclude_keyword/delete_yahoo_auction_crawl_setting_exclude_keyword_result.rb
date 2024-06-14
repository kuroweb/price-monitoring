module GraphqlSchema
  module Unions
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeKeyword
        class DeleteYahooAuctionCrawlSettingExcludeKeywordResult < Base
          possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                         DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess,
                         Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                         DeleteYahooAuctionCrawlSettingExcludeKeywordResultError

          def self.resolve_type(object, _context)
            case object[:__typename]
            when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess"
              Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
              DeleteYahooAuctionCrawlSettingExcludeKeywordResultSuccess
            when "DeleteYahooAuctionCrawlSettingExcludeKeywordResultError"
              Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
              DeleteYahooAuctionCrawlSettingExcludeKeywordResultError
            else
              raise "Unexpected DeleteYahooAuctionCrawlSettingExcludeKeywordResult: #{object}"
            end
          end
        end
      end
    end
  end
end
