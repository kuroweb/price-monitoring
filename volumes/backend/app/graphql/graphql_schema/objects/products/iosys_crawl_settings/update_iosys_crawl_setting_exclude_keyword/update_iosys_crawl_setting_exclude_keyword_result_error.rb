module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeKeyword
          class UpdateIosysCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::Products::ResultBase

            field :error,
                  Unions::Products::IosysCrawlSettings::UpdateIosysCrawlSettingExcludeKeyword::
                  UpdateIosysCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
