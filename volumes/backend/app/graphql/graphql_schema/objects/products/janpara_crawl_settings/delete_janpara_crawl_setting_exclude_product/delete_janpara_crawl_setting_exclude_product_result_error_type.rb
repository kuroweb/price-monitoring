module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeProduct
          class DeleteJanparaCrawlSettingExcludeProductResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeProduct::
                  DeleteJanparaCrawlSettingExcludeProductResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
