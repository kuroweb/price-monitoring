module GraphqlSchema
  module InputObjects
    module Products
      module IosysCrawlSettings
        class CreateIosysCrawlSettingExcludeKeywordInput < Base
          argument :product_id, ID, required: true
          argument :keyword, String, required: false
        end
      end
    end
  end
end
