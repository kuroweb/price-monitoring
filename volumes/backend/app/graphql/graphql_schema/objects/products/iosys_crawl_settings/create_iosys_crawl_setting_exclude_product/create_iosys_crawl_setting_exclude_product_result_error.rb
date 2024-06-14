module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::CreateIosysCrawlSettingExcludeProduct::
                  CreateIosysCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
