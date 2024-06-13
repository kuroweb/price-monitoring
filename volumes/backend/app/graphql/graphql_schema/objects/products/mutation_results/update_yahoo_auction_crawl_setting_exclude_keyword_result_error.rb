module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class UpdateYahooAuctionCrawlSettingExcludeKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error, Unions::Products::UpdateYahooAuctionCrawlSettingExcludeKeywordResultErrors, null: false
        end
      end
    end
  end
end
