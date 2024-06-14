module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeProduct
          class DeleteIosysCrawlSettingExcludeProductResultError < Base
            implements Interfaces::Products::ResultBase

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
