module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingRequiredKeyword
          class UpdateIosysCrawlSettingRequiredKeywordResultValidationFailedType < Base
            implements Interfaces::UserError

            field :details, [ErrorDetailType], null: false
          end
        end
      end
    end
  end
end
