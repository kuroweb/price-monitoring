module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingRequiredKeyword
          class DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingRequiredKeyword::
                  DeleteUsedSofmapCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
