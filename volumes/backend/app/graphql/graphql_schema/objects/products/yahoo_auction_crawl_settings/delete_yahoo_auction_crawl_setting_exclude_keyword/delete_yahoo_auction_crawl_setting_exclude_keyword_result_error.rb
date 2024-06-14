module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeKeyword
          class DeleteYahooAuctionCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                  DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
