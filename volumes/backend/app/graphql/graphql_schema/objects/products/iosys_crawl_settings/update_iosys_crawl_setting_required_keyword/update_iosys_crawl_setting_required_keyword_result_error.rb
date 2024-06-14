module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingRequiredKeyword::
                  UpdateIosysCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
