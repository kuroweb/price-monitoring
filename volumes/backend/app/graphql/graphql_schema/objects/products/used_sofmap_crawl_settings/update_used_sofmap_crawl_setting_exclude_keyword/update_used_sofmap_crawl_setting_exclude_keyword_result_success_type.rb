module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeKeyword
          class UpdateUsedSofmapCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :used_sofmap_crawl_setting_exclude_keyword,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingExcludeKeywordType, null: false
          end
        end
      end
    end
  end
end
