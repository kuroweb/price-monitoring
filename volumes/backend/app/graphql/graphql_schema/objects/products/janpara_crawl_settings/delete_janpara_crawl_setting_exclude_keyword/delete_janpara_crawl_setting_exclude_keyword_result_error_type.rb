module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module DeleteJanparaCrawlSettingExcludeKeyword
          class DeleteJanparaCrawlSettingExcludeKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::DeleteJanparaCrawlSettingExcludeKeyword::
                  DeleteJanparaCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
