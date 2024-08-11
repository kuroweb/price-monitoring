module GraphqlSchema
  module Objects
    module Products
      module MercariCrawlSettings
        module CreateMercariCrawlSettingExcludeKeyword
          class CreateMercariCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::MercariCrawlSettings::CreateMercariCrawlSettingExcludeKeyword::
                  CreateMercariCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
