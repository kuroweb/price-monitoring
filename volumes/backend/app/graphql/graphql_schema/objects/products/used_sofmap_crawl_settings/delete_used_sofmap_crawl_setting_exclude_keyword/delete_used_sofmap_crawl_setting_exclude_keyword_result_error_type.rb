module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeKeyword
          class DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeKeyword::
                  DeleteUsedSofmapCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
