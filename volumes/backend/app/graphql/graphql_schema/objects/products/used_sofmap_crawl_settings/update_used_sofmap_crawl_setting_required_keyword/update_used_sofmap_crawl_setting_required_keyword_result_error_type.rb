module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingRequiredKeyword
          class UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingRequiredKeyword::
                  UpdateUsedSofmapCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
