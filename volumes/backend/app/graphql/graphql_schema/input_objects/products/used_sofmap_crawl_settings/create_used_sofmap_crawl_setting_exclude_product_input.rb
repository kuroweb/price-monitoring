module GraphqlSchema
  module InputObjects
    module Products
      module UsedSofmapCrawlSettings
        class CreateUsedSofmapCrawlSettingExcludeProductInput < Base
          argument :product_id, ID, required: true
          argument :external_id, String, required: true
        end
      end
    end
  end
end
