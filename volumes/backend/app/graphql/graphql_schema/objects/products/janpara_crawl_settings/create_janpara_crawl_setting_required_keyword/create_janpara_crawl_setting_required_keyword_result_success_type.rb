module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResultSuccessType < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_required_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingRequiredKeywordType,
                  null: false
          end
        end
      end
    end
  end
end
