module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeProduct
          class CreateUsedSofmapCrawlSettingExcludeProductResultSuccess < Base
            implements Interfaces::ResultBase

            field :used_sofmap_crawl_setting_exclude_product,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingExcludeProduct,
                  null: false
          end
        end
      end
    end
  end
end
