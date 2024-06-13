module GraphqlSchema
  module InputObjects
    module Products
      class DeleteYahooAuctionCrawlSettingExcludeKeywordInput < Base
        argument :id, ID, required: true
        argument :product_id, ID, required: true
      end
    end
  end
end
