module GraphqlSchema
  module Objects
    module Products
      module CreateYahooAuctionCrawlSettingExcludeProduct
        class CreateYahooAuctionCrawlSettingExcludeProductResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
