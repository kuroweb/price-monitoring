module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module CreateUsedSofmapCrawlSettingExcludeProduct
          class CreateUsedSofmapCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::UsedSofmapCrawlSettings::CreateUsedSofmapCrawlSettingExcludeProduct::
                  CreateUsedSofmapCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
