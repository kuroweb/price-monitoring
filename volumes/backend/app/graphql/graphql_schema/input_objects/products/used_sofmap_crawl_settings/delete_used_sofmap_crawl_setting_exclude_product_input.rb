module GraphqlSchema
  module InputObjects
    module Products
      module UsedSofmapCrawlSettings
        class DeleteUsedSofmapCrawlSettingExcludeProductInput < Base
          argument :id, ID, required: true
          argument :product_id, ID, required: true
        end
      end
    end
  end
end
