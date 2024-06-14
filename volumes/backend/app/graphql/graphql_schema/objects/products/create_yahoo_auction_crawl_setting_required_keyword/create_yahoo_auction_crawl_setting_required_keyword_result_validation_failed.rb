module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingRequiredKeyword
        class CreateYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
