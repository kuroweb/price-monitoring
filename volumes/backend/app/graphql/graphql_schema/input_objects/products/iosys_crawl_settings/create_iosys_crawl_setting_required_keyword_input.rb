module GraphqlSchema
  module InputObjects
    module Products
      module IosysCrawlSettings
        class CreateIosysCrawlSettingRequiredKeywordInput < Base
          argument :product_id, ID, required: true
          argument :keyword, String, required: false
        end
      end
    end
  end
end
