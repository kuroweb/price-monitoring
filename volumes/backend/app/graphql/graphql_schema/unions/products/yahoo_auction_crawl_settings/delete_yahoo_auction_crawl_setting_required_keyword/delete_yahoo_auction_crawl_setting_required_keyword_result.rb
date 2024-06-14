module GraphqlSchema
  module Unions
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingRequiredKeyword
          class DeleteYahooAuctionCrawlSettingRequiredKeywordResult < Base
            possible_types Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                           DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess,
                           Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                           DeleteYahooAuctionCrawlSettingRequiredKeywordResultError

            def self.resolve_type(object, _context)
              case object[:__typename]
              when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultSuccess
              when "DeleteYahooAuctionCrawlSettingRequiredKeywordResultError"
                Objects::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultError
              else
                raise "Unexpected DeleteYahooAuctionCrawlSettingRequiredKeywordResult: #{object}"
              end
            end
          end
        end
      end
    end
  end
end
