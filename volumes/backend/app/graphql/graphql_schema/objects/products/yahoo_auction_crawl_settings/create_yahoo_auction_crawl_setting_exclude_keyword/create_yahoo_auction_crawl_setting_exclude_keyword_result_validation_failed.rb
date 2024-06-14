module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module CreateYahooAuctionCrawlSettingExcludeKeyword
          class CreateYahooAuctionCrawlSettingExcludeKeywordResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
