module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeKeyword
          class UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::UpdateUsedSofmapCrawlSettingExcludeKeyword::
                  UpdateUsedSofmapCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
