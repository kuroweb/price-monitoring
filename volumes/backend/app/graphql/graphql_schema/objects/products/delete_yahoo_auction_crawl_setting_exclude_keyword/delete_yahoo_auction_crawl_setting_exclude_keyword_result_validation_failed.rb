module GraphqlSchema
  module Objects
    module Products
      module DeleteYahooAuctionCrawlSettingExcludeKeyword
        class DeleteYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed < Base
          implements Interfaces::Products::UserError

          field :details, [ErrorDetail], null: false
        end
      end
    end
  end
end
