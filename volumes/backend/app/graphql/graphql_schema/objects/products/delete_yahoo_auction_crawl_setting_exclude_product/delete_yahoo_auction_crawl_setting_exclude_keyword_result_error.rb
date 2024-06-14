module GraphqlSchema
  module Objects
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeProduct
        class DeleteYahooAuctionCrawlSettingExcludeProductResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::DeleteYahooAuctionCrawlSettingExcludeProduct::
                DeleteYahooAuctionCrawlSettingExcludeProductResultErrors,
                null: false
        end
      end
    end
  end
end
