module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingRequiredKeyword
          class DeleteMercariCrawlSettingRequiredKeywordResultValidationFailedType < Base
            implements Interfaces::UserError

            field :details, [ErrorDetailType], null: false
          end
        end
      end
    end
  end
end
