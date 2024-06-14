module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeKeyword
          class CreateIosysCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeKeyword::
                  CreateIosysCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
