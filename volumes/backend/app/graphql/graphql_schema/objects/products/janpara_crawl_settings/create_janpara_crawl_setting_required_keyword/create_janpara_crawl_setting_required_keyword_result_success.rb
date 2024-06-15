module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::Products::ResultBase

            field :janpara_crawl_setting_required_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingRequiredKeyword,
                  null: false
          end
        end
      end
    end
  end
end
