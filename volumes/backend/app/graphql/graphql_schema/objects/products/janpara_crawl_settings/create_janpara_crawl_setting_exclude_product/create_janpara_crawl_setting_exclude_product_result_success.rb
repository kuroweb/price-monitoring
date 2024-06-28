module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeProduct
          class CreateJanparaCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_product,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeProduct,
                  null: false
          end
        end
      end
    end
  end
end
