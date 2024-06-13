module GraphqlSchema
  module Objects
    module Products
      module MutationResults
        class CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
