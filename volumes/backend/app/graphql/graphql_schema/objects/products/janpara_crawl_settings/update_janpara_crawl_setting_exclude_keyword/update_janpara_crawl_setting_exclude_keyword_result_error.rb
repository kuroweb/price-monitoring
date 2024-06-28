module GraphqlSchema
  module Objects
    module Products
      module JanparaCrawlSettings
        module UpdateJanparaCrawlSettingExcludeKeyword
          class UpdateJanparaCrawlSettingExcludeKeywordResultError < Base
            implements Interfaces::ResultBase

            field :error,
                  Unions::Products::JanparaCrawlSettings::UpdateJanparaCrawlSettingExcludeKeyword::
                  UpdateJanparaCrawlSettingExcludeKeywordResultErrors,
                  null: false
          end
        end
      end
    end
  end
end
