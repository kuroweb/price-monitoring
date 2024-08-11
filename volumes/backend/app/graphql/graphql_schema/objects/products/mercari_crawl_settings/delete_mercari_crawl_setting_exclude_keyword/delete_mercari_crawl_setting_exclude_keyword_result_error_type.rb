module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module DeleteMercariCrawlSettingExcludeKeyword
          class DeleteMercariCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::DeleteMercariCrawlSettingExcludeKeyword::
                  DeleteMercariCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
