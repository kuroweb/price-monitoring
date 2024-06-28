module GraphqlSchema
  module Objects
    module Products
      module UsedSofmapCrawlSettings
        module DeleteUsedSofmapCrawlSettingRequiredKeyword
          class DeleteUsedSofmapCrawlSettingRequiredKeywordResultValidationFailed < Base
            implements Interfaces::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
