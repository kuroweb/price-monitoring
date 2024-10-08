module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingRequiredKeyword
          class UpdateJanparaCrawlSettingRequiredKeywordResultErrorType < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingRequiredKeyword::
                  UpdateJanparaCrawlSettingRequiredKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
