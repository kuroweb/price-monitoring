module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                  UpdateIosysCrawlSettingRequiredKeywordResultErrorsUnion,
                  null: false
          end
        end
      end
    end
  end
end
