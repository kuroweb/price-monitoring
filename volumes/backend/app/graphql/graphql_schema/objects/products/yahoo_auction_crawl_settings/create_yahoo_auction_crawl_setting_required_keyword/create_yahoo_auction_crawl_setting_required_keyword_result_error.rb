module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingRequiredKeyword
          class CreateYahooAuctionCrawlSettingRequiredKeywordResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingRequiredKeyword::
                  CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
