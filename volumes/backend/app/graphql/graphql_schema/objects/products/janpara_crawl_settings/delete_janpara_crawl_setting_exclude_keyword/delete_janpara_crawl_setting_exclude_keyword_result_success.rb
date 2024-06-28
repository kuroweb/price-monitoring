module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeKeyword
          class DeleteJanparaCrawlSettingExcludeKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeKeyword, null: false
          end
        end
      end
    end
  end
end
