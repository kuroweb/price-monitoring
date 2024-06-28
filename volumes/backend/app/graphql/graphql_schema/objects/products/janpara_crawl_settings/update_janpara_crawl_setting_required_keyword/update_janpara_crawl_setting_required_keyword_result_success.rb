module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResultSuccess < Base
            implements Interfaces::ResultBase

            field :janpara_crawl_setting_required_keyword,
                  Objects::Products::JanparaCrawlSettings::JanparaCrawlSettingRequiredKeyword, null: false
          end
        end
      end
    end
  end
end
