module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::CreateYahooAuctionCrawlSettingExcludeProduct::
                CreateYahooAuctionCrawlSettingExcludeProductResultErrors,
                null: false
        end
      end
    end
  end
end
