module GraphqlSchema
  module InputObjects
    module Products
      module UpdateProduct
        class UpdatePcKoubouCrawlSettingInput < Base
          argument :keyword, String, required: true
          argument :min_price, Int, required: true
          argument :max_price, Int, required: true
          argument :enabled, Boolean, required: true
        end
      end
    end
  end
end
