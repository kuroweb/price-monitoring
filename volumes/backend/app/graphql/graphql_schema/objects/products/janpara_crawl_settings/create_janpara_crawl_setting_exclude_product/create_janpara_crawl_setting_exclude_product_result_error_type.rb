module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeProduct
          class CreateJanparaCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeProduct::
                  CreateJanparaCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
