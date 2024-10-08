module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingExcludeKeyword
          class UpdateMercariCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::UpdateMercariCrawlSettingExcludeKeyword::
                  UpdateMercariCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
