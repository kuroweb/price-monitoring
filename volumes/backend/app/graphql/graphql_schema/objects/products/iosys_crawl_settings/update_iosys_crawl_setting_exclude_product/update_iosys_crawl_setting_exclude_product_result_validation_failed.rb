module GraphqlSchema
  module Objects
    module Products
      module IosysCrawlSettings
        module UpdateIosysCrawlSettingExcludeProduct
          class UpdateIosysCrawlSettingExcludeProductResultValidationFailed < Base
            implements Interfaces::Products::UserError

            field :details, [ErrorDetail], null: false
          end
        end
      end
    end
  end
end
