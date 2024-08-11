module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingRequiredKeyword
          class CreateUsedSofmapCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :used_sofmap_crawl_setting_required_keyword,
                  Objects::Products::UsedSofmapCrawlSettings::UsedSofmapCrawlSettingRequiredKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
