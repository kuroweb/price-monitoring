module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeKeyword
          class UpdateJanparaCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeKeyword, null: false
          end
        end
      end
    end
  end
end
