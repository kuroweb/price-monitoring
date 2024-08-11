module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module CreateIosysCrawlSettingExcludeProduct
          class CreateIosysCrawlSettingExcludeProductResultValidationFailedType < Base
            implements Interfaces::UserError

            field :details, [ErrorDetailType], null: false
          end
        end
      end
    end
  end
end
