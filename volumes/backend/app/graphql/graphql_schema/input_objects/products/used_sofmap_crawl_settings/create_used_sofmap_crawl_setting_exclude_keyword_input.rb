module GraphqlSchema
  module InputObjects
    module Products
      module UsedSofmapCrawlSettings
        class CreateUsedSofmapCrawlSettingExcludeKeywordInput < Base
          argument :product_id, ID, required: true
          argument :keyword, String, required: false
        end
      end
    end
  end
end
