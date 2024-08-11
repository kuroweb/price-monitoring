module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingRequiredKeyword
          class CreateUsedSofmapCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingRequiredKeyword::
                  CreateUsedSofmapCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
