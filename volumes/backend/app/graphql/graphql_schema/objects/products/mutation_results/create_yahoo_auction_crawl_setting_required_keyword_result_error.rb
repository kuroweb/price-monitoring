module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class CreateYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::CreateYahooAuctionCrawlSettingRequiredKeywordResultErrors, null: false
        end
      end
    end
  end
end
