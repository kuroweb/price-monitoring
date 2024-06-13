module GraphqlSchema
  module InputObjects
    module Products
      class DeleteYahooAuctionCrawlSettingRequiredKeywordInput < Base
        argument :id, ID, required: true
        argument :product_id, ID, required: true
      end
    end
  end
end
