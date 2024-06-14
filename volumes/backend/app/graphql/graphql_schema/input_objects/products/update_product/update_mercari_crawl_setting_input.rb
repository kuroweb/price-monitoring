module GraphqlSchema
  module InputObjects
    module Products
      module UpdateProduct
        class UpdateMercariCrawlSettingInput < Base
          argument :keyword, String, required: true
          argument :category_id, Int, required: false
          argument :min_price, Int, required: true
          argument :max_price, Int, required: true
          argument :enabled, Boolean, required: true
        end
      end
    end
  end
end
