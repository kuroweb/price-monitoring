module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeProduct
          class DeleteIosysCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeProduct::
                  DeleteIosysCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
