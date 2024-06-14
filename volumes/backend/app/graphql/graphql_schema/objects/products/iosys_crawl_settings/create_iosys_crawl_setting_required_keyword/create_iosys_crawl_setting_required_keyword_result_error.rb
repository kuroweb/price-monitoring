module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingRequiredKeyword
          class CreateIosysCrawlSettingRequiredKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::CreateIosysCrawlSettingRequiredKeyword::
                  CreateIosysCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
