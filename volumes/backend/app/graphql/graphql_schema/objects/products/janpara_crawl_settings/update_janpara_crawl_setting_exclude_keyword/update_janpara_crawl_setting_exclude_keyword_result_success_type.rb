module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeKeyword
          class UpdateJanparaCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeKeywordType, null: false
          end
        end
      end
    end
  end
end
