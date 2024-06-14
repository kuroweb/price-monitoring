module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::DeleteIosysCrawlSettingRequiredKeyword::
                  DeleteIosysCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
