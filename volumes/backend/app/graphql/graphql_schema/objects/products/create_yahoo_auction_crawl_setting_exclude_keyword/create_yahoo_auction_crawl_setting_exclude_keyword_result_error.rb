module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingExcludeKeyword
        class CreateYahooAuctionCrawlSettingExcludeKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::CreateYahooAuctionCrawlSettingExcludeKeyword::
                CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                null: false
        end
      end
    end
  end
end
