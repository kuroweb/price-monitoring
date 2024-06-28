module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :used_sofmap_crawl_setting_exclude_keyword,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingExcludeKeyword,
                  null: false
          end
        end
      end
    end
  end
end
