module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module DeleteIosysCrawlSettingRequiredKeyword
          class DeleteIosysCrawlSettingRequiredKeywordResultValidationFailed < Base
            implements Interfaces::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
