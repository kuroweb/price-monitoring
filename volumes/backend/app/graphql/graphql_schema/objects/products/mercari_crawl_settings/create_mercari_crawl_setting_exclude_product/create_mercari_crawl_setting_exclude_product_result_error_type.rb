module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeProduct
          class CreateMercariCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeProduct::
                  CreateMercariCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
