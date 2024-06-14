module GraphqlSchema
  module Objects
    module Products
      module UpdateYahooAuctionCrawlSettingRequiredKeyword
        class UpdateYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::UpdateYahooAuctionCrawlSettingRequiredKeyword::
                UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors,
                null: false
        end
      end
    end
  end
end
