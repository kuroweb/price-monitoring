module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeProduct
          class UpdateMercariCrawlSettingExcludeProductResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeProduct::
                  UpdateMercariCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
