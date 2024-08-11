module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                  UpdateIosysCrawlSettingExcludeKeywordResultErrorsUnion,
                  null: false
          end
        end
      end
    end
  end
end
