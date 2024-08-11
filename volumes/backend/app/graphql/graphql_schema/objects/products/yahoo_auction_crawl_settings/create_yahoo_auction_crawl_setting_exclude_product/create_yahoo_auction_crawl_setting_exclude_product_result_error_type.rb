module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeProduct
          class CreateYahooAuctionCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::CreateYahooAuctionCrawlSettingExcludeProduct::
                  CreateYahooAuctionCrawlSettingExcludeProductResultErrorsUnion,
                  null: false
          end
        end
      end
    end
  end
end
