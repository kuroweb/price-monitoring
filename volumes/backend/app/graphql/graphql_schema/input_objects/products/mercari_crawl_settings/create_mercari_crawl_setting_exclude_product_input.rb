module GraphqlSchema
  module InputObjects
    module Products
      module MercariCrawlSettings
        class CreateMercariCrawlSettingExcludeProductInput < Base
          argument :product_id, ID, required: true
          argument :external_id, String, required: true
        end
      end
    end
  end
end
