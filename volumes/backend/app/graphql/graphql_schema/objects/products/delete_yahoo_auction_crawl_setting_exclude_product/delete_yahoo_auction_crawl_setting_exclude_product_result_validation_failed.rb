module GraphqlSchema
  module Objects
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeProduct
        class DeleteYahooAuctionCrawlSettingExcludeProductResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
