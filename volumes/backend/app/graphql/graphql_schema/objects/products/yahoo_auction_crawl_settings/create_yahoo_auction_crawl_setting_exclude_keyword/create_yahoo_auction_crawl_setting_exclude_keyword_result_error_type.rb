module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeKeyword
          class CreateYahooAuctionCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeKeyword::
                  CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
