module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeKeyword
          class DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeKeyword::
                  DeleteYahooAuctionCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
