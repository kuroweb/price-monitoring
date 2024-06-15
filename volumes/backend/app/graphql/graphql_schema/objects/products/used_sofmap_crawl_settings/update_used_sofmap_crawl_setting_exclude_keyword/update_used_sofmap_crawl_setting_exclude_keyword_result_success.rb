module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeKeyword
          class UpdateUsedSofmapCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :used_sofmap_crawl_setting_exclude_keyword,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingExcludeKeyword, null: false
          end
        end
      end
    end
  end
end
