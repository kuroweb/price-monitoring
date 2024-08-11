module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingRequiredKeyword
          class DeleteJanparaCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingRequiredKeyword::
                  DeleteJanparaCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
