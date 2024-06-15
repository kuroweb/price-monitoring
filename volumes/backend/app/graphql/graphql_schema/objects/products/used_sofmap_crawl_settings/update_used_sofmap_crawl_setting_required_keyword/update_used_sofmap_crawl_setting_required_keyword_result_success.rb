module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :used_sofmap_crawl_setting_required_keyword,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
