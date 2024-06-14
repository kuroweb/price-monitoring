module GraphqlSchema
  module Objects
    module Products
      module DeleteYahooAuctionCrawlSettingRequiredKeyword
        class DeleteYahooAuctionCrawlSettingRequiredKeywordResultError < Base
          implements Interfaces::Products::ResultBase

          field :error,
                Unions::Products::DeleteYahooAuctionCrawlSettingRequiredKeyword::
                DeleteYahooAuctionCrawlSettingRequiredKeywordResultErrors,
                null: false
        end
      end
    end
  end
end
