module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeProduct
          class UpdateJanparaCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_product,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end
