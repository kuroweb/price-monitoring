module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class DeleteYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors, null: false
        end
      end
    end
  end
end
