module GraphqlSchema
  module InputObjects
    module Products
      module PcKoubouCrawlSettings
        class CreatePcKoubouCrawlSettingRequiredKeywordInput < Base
          argument :product_id, ID, required: true
          argument :keyword, String, required: false
        end
      end
    end
  end
end
