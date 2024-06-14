module GraphqlSchema
  module Objects
    module Products
      module DeleteYahooAuctionCrawlSettingRequiredKeyword
        class DeleteYahooAuctionCrawlSettingRequiredKeywordResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
