module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                  CreateIosysCrawlSettingRequiredKeywordResultErrorsUnion,
                  null: false
          end
        end
      end
    end
  end
end
