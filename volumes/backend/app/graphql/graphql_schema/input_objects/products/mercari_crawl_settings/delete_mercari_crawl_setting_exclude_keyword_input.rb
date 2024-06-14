module GraphqlSchema
  module InputObjects
    module Products
      module MercariCrawlSettings
        class DeleteMercariCrawlSettingExcludeKeywordInput < Base
          argument :id, ID, required: true
          argument :product_id, ID, required: true
        end
      end
    end
  end
end
