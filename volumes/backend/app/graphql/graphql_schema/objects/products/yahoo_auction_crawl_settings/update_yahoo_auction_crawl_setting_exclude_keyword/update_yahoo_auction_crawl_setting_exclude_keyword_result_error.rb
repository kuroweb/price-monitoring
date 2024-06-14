module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeKeyword
          class UpdateYahooAuctionCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::UpdateYahooAuctionCrawlSettingExcludeKeyword::
                  UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
