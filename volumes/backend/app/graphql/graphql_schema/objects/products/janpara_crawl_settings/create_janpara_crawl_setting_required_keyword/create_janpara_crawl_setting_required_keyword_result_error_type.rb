module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingRequiredKeyword
          class CreateJanparaCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingRequiredKeyword::
                  CreateJanparaCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
