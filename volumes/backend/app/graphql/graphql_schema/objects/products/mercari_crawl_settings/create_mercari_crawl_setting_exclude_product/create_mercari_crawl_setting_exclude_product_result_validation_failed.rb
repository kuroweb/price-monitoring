module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResultValidationFailed < Base
            implements Interfaces::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
