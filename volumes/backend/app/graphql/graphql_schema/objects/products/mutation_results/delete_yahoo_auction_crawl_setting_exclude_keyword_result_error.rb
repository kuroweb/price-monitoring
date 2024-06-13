module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class DeleteYahooAuctionCrawlSettingExcludeKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors, null: false
        end
      end
    end
  end
end
