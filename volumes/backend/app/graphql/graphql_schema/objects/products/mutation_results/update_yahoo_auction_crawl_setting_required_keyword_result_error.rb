module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class UpdateYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::UpdateYahooAuctionCrawlSettingRequiredKeywordResultErrors, null: false
        end
      end
    end
  end
end
