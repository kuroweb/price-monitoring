module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class CreateYahooAuctionCrawlSettingExcludeKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::CreateYahooAuctionCrawlSettingExcludeKeywordResultErrors, null: false
        end
      end
    end
  end
end
