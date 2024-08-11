module GraphqlSchema
  module Objects
    module Products
      module YahooAuctionCrawlSettings
        module DeleteYahooAuctionCrawlSettingExcludeProduct
          class DeleteYahooAuctionCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::YahooAuctionCrawlSettings::DeleteYahooAuctionCrawlSettingExcludeProduct::
                  DeleteYahooAuctionCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
