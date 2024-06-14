module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingRequiredKeyword
        class CreateYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::CreateYahooAuctionCrawlSettingRequiredKeyword::
                CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors,
                null: false
        end
      end
    end
  end
end
