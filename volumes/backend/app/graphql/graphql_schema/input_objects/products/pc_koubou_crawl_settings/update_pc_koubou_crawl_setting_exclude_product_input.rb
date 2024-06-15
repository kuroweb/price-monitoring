module GraphqlSchema
  module InputObjects
    module Products
      module PcKoubouCrawlSettings
        class UpdatePcKoubouCrawlSettingExcludeProductInput < Base
          argument :id, ID, required: true
          argument :product_id, ID, required: true
          argument :external_id, String, required: true
        end
      end
    end
  end
end
