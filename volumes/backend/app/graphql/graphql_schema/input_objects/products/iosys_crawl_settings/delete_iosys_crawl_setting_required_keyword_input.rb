module GraphqlSchema
  module InputObjects
    module Products
      module IosysCrawlSettings
        class DeleteIosysCrawlSettingRequiredKeywordInput < Base
          argument :id, ID, required: true
          argument :product_id, ID, required: true
        end
      end
    end
  end
end
