module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeKeyword
          class UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                  UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
