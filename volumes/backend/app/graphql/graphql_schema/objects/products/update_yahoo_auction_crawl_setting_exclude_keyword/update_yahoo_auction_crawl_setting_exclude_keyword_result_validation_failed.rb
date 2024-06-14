module GraphqlSchema
  module Objects
    module Products
      module UpdateYahooAuctionCrawlSettingExcludeKeyword
        class UpdateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
