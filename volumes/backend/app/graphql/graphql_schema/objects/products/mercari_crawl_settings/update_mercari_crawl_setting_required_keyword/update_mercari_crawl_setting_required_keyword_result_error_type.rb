module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module UpdateMercariCrawlSettingRequiredKeyword
          class UpdateMercariCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::UpdateMercariCrawlSettingRequiredKeyword::
                  UpdateMercariCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
