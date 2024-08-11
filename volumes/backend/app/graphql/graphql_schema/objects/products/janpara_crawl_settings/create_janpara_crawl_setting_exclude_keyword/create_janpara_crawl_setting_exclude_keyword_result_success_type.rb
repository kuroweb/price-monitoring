module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_exclude_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingExcludeKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
