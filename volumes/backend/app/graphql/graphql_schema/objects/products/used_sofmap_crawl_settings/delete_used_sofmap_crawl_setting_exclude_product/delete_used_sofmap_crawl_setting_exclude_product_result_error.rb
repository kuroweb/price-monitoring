module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingExcludeProduct
          class DeleteUsedSofmapCrawlSettingExcludeProductResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::DeleteUsedSofmapCrawlSettingExcludeProduct::
                  DeleteUsedSofmapCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
