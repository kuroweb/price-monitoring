module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module UpdateYahooAuctionCrawlSettingExcludeProduct
          class UpdateYahooAuctionCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::UpdateYahooAuctionCrawlSettingExcludeProduct::
                  UpdateYahooAuctionCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
