module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeProduct
          class DeleteMercariCrawlSettingExcludeProductResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeProduct::
                  DeleteMercariCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
