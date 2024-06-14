module GraphqlSchema
  module Objects
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeProduct
        class UpdateYahooAuctionCrawlSettingExcludeProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::UpdateYahooAuctionCrawlSettingExcludeProduct::
                UpdateYahooAuctionCrawlSettingExcludeProductResultErrors,
                null: false
        end
      end
    end
  end
end
