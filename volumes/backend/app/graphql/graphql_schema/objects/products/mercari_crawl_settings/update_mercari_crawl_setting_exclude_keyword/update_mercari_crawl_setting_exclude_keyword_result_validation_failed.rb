module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResultValidationFailed < Base
            implements Interfaces::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
