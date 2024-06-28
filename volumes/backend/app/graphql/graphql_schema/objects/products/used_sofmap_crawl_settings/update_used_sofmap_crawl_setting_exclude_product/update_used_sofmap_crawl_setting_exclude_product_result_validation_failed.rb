module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module UpdateUsedSofmapCrawlSettingExcludeProduct
          class UpdateUsedSofmapCrawlSettingExcludeProductResultValidationFailed < Base
            implements Interfaces::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
