module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::DeleteIosysCrawlSettingExcludeKeyword::
                  DeleteIosysCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
