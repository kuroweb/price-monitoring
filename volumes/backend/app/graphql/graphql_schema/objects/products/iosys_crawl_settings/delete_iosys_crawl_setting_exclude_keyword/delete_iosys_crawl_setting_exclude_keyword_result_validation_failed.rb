module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingExcludeKeyword
          class DeleteIosysCrawlSettingExcludeKeywordResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
