module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeProduct
          class UpdateUsedSofmapCrawlSettingExcludeProductResultSuccessType < Base
            implements Interfaces::ResultBase

            field :used_sofmap_crawl_setting_exclude_product,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingExcludeProductType, null: false
          end
        end
      end
    end
  end
end