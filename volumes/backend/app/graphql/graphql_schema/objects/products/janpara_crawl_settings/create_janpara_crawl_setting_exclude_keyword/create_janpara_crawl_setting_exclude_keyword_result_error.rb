module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module CreateJanparaCrawlSettingExcludeKeyword
          class CreateJanparaCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::CreateJanparaCrawlSettingExcludeKeyword::
                  CreateJanparaCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
