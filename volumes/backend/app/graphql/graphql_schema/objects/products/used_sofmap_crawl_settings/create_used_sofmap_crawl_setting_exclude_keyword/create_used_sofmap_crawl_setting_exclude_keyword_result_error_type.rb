module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeKeyword
          class CreateUsedSofmapCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeKeyword::
                  CreateUsedSofmapCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
