module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :janpara_crawl_setting_exclude_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeKeyword,
                  null: false
          end
        end
      end
    end
  end
end
